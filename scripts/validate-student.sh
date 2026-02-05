#!/bin/bash
set -e

STUDENT_FILE="$1"

if [ ! -f "$STUDENT_FILE" ]; then
    echo "❌ Student file not found: $STUDENT_FILE"
    exit 1
fi

echo "=== Validating Student Submissions ==="
echo "File: $STUDENT_FILE"
echo ""

# Extract students array
STUDENT_COUNT=$(yq eval '.students | length' "$STUDENT_FILE")
echo "Found $STUDENT_COUNT student(s) to validate"
echo ""

FAILED=0

for i in $(seq 0 $((STUDENT_COUNT - 1))); do
    NAME=$(yq eval ".students[$i].name" "$STUDENT_FILE")
    USERNAME=$(yq eval ".students[$i].github_username" "$STUDENT_FILE")
    IMAGE=$(yq eval ".students[$i].container_image" "$STUDENT_FILE")
    PORT=$(yq eval ".students[$i].port" "$STUDENT_FILE")

    # Skip if null (commented out entries)
    if [ "$NAME" == "null" ] || [ "$USERNAME" == "null" ]; then
        continue
    fi

    echo "─────────────────────────────────────"
    echo "Validating: $NAME (@$USERNAME)"
    echo "Image: $IMAGE"
    echo ""

    # Validate required fields
    if [ "$NAME" == "null" ] || [ -z "$NAME" ]; then
        echo "❌ Missing required field: name"
        FAILED=1
        continue
    fi

    if [ "$USERNAME" == "null" ] || [ -z "$USERNAME" ]; then
        echo "❌ Missing required field: github_username"
        FAILED=1
        continue
    fi

    if [ "$IMAGE" == "null" ] || [ -z "$IMAGE" ]; then
        echo "❌ Missing required field: container_image"
        FAILED=1
        continue
    fi

    # Validate image is on GHCR
    if [[ ! "$IMAGE" =~ ^ghcr\.io/.+/.+:.+ ]]; then
        echo "❌ Image must be from GHCR (ghcr.io/username/repo:tag)"
        FAILED=1
        continue
    fi

    # Check if image is publicly accessible
    echo "  → Checking image accessibility..."
    if docker manifest inspect "$IMAGE" > /dev/null 2>&1; then
        echo "  ✅ Image is publicly accessible"
    else
        echo "  ❌ Image not found or not public: $IMAGE"
        echo "     Make sure your GHCR package is set to Public!"
        FAILED=1
        continue
    fi

    # Try to pull and test the container (optional - can be slow)
    if [ "${DEEP_VALIDATION:-false}" == "true" ]; then
        echo "  → Running deep validation (starting container)..."

        CONTAINER_ID=$(docker run -d -p 5000:${PORT:-5000} "$IMAGE" 2>/dev/null || echo "failed")

        if [ "$CONTAINER_ID" == "failed" ]; then
            echo "  ⚠️  Could not start container (skipping endpoint checks)"
        else
            # Wait for container to be ready
            sleep 5

            # Check /health endpoint
            if curl -f -s http://localhost:5000/health > /dev/null 2>&1; then
                echo "  ✅ /health endpoint responding"
            else
                echo "  ⚠️  /health endpoint not accessible"
            fi

            # Check /student endpoint
            STUDENT_DATA=$(curl -f -s http://localhost:5000/student 2>/dev/null || echo "failed")
            if [ "$STUDENT_DATA" != "failed" ]; then
                echo "  ✅ /student endpoint responding"

                # Validate JSON structure
                if echo "$STUDENT_DATA" | jq -e '.name and .github_username' > /dev/null 2>&1; then
                    echo "  ✅ Student data has required fields"

                    # Extract name from response
                    RESPONSE_NAME=$(echo "$STUDENT_DATA" | jq -r '.name')
                    echo "  📝 Student name from container: $RESPONSE_NAME"
                else
                    echo "  ⚠️  Student data missing required fields (name, github_username)"
                fi
            else
                echo "  ⚠️  /student endpoint not accessible"
            fi

            # Cleanup
            docker rm -f "$CONTAINER_ID" > /dev/null 2>&1
        fi
    fi

    echo "  ✅ Validation passed for $USERNAME"
    echo ""
done

if [ $FAILED -ne 0 ]; then
    echo "❌ Validation failed for one or more students"
    exit 1
fi

echo "✅ All validations passed!"
