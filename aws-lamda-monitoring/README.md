# 🖼️ LocalStack Image Processor with Comprehensive Monitoring

A local development setup for AWS Lambda image processing using LocalStack, with enterprise-grade CloudWatch monitoring, implemented using modular Terraform.

## 📋 Overview

This project demonstrates AWS serverless best practices locally using LocalStack:

- **Lambda-based image processing** (resize, compress, format conversion)
- **S3 event-driven architecture** (automatic triggering)
- **Comprehensive CloudWatch monitoring** (metrics, alarms, dashboards)
- **SNS alerting** (local email/SMS notifications)
- **Modular Terraform** (reusable, maintainable infrastructure)
- **100% Local Development** (no AWS credentials needed)

### What It Does

1. 📤 Upload an image to S3 upload bucket (local)
2. ⚡ Lambda function automatically triggers (local)
3. 🎨 Processes image (creates 5 variants: compressed, low-quality, WebP, PNG, thumbnail)
4. 📥 Saves processed images to destination bucket (local)
5. 📊 Monitors everything with CloudWatch metrics and alarms (local)
6. 📧 Sends alerts via SNS when issues occur (local)

---

## 🏗️ Architecture (LocalStack)

```
┌─────────────────┐
│  LocalStack     │
│  S3 Upload      │
│  Bucket         │──────┐
└─────────────────┘      │
                         │ S3 Event
                         ▼
              ┌───────────────────┐
              │  LocalStack       │
              │  Lambda           │
              │  Function         │
              └───────┬───────────┘
                      │
      ┌───────────────┼───────────────┐
      │               │               │
      ▼               ▼               ▼
┌──────────────┐ ┌──────────────┐ ┌─────────────┐
│ LocalStack   │ │ LocalStack   │ │ LocalStack  │
│ S3 Processed │ │ CloudWatch   │ │ SNS Topics  │
│ Bucket       │ │ Logs         │ │             │
└──────────────┘ └──────┬───────┘ └──────┬──────┘
                        │                 │
                        ▼                 ▼
                 ┌──────────────┐  ┌─────────────┐
                 │ Metrics &    │  │ Local Email/│
                 │ Alarms       │  │ Logs        │
                 └──────────────┘  └─────────────┘
```

---

## 🎯 Key Features

### Image Processing

- ✅ Multiple format support (JPEG, PNG, WebP, BMP, TIFF)
- ✅ Automatic format conversion
- ✅ Quality-based compression (85%, 60%)
- ✅ Thumbnail generation (300x300)
- ✅ Large image resizing (max 4096px)
- ✅ Automatic color space conversion

### Monitoring & Observability

- ✅ **12 CloudWatch Alarms** (local):
  - Error rate monitoring
  - Duration/timeout warnings
  - Throttle detection
  - Memory usage tracking
  - Concurrent execution limits
  - Log-based error patterns
- ✅ **Custom Metrics**:
  - Image processing time
  - Image sizes processed
  - Success/failure rates
  - Business-level insights
- ✅ **Comprehensive Dashboard**:
  - Real-time metrics visualization (local)
  - Custom metrics
  - Log insights integration
  - Performance trends
- ✅ **Log-Based Alerts**:
  - Timeout detection
  - Memory errors
  - S3 permission issues
  - Image processing failures
  - Critical application errors

### Infrastructure

- ✅ **Modular Terraform** (6 reusable modules)
- ✅ **Security best practices** (IAM least privilege, S3 encryption)
- ✅ **Scalable architecture** (auto-scaling Lambda)
- ✅ **Cost-free Development** (use LocalStack instead of AWS)
- ✅ **Environment-agnostic** (dev/staging/prod)
- ✅ **Docker-based** (runs in containers)

---

## 📁 Project Structure

```
localstack-image-processor/
├── lambda/
│   ├── lambda_function.py       # Enhanced Lambda with structured logging
│   └── requirements.txt         # Python dependencies (Pillow)
├── scripts/
│   ├── build_layer_docker.sh   # Build Pillow layer using Docker
│   ├── build_layer_local.sh    # Build Pillow layer locally
│   ├── deploy.sh               # Deployment automation
├── terraform/
│   ├── main.tf                 # Root module orchestration
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Output values
│   ├── provider.tf             # LocalStack provider configuration
│   ├── terraform.tfvars.example# LocalStack configuration example
│   └── modules/
│       ├── lambda_function/    # Lambda + IAM + CloudWatch Logs
│       ├── s3_buckets/         # S3 buckets with security
│       ├── sns_notifications/  # SNS topics + subscriptions
│       ├── cloudwatch_metrics/ # Metrics, filters, dashboard
│       ├── cloudwatch_alarms/  # Standard CloudWatch alarms
│       └── log_alerts/         # Log-based metric filters + alarms
├── tests/
│   ├── sample_image.jpg        # Test image
│   └── invalid_image.jpg       # Test error case
└── README.md                   # This file
```

---

## 🚀 Quick Start with LocalStack

### Prerequisites

- Docker & Docker Compose
- AWS CLI (configured for LocalStack)
- Terraform >= 1.0
- Python 3.12
- Git

### Installation & Setup

#### 1. Clone Repository

```bash
git clone
cd localstack-image-processor
```

#### 2. Start LocalStack

```bash
docker-compose up -d
```

**Wait 30-60 seconds for services to be ready.**

Verify LocalStack is running:

```bash
docker ps
# Should see: localstack/localstack, postgres (for LocalStack)

# Check if services are ready
docker logs localstack-main | grep "Ready to handle"
```

#### 3. Configure AWS CLI for LocalStack

```bash
# Set LocalStack endpoint
export AWS_ENDPOINT_URL_S3=http://localhost:4566
export AWS_ENDPOINT_URL_LAMBDA=http://localhost:4566
export AWS_ENDPOINT_URL_LOGS=http://localhost:4566
export AWS_ENDPOINT_URL_SNS=http://localhost:4566
export AWS_ENDPOINT_URL_CLOUDWATCH=http://localhost:4566

# Set dummy credentials
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1

# Or add to ~/.bashrc or ~/.zshrc for persistence
```

**Tip:** Create a file `localstack.env`:

```bash
export AWS_ENDPOINT_URL_S3=http://localhost:4566
export AWS_ENDPOINT_URL_LAMBDA=http://localhost:4566
export AWS_ENDPOINT_URL_LOGS=http://localhost:4566
export AWS_ENDPOINT_URL_SNS=http://localhost:4566
export AWS_ENDPOINT_URL_CLOUDWATCH=http://localhost:4566
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
```

Then run: `source localstack.env`

#### 4. Build Lambda Layer

```bash
cd scripts

# Option A: Docker-based build (recommended)
chmod +x build_layer_docker.sh
./build_layer_docker.sh

# Option B: Local Python build (if you have Python 3.12)
chmod +x build_layer_local.sh
./build_layer_local.sh
```

Creates `pillow_layer.zip` in the terraform directory.

#### 5. Deploy Infrastructure

```bash
cd ../terraform

# Initialize Terraform
terraform init

# Review what will be created
terraform plan

# Deploy to LocalStack
terraform apply
# Type 'yes' to confirm
```

⏱️ **Deployment time:** ~30-60 seconds (much faster than AWS!)

📝 **Resources created:** 40+ resources (all local)

#### 6. Capture Outputs

```bash
terraform output
```

Save the bucket names for testing.

---

## 🧪 Testing with LocalStack

### 1. Upload Test Image

```bash
# Get bucket name
UPLOAD_BUCKET=$(terraform output -raw upload_bucket_name)

# Upload sample image
aws s3 cp ../tests/sample_image.jpg s3://$UPLOAD_BUCKET/ \
  --endpoint-url http://localhost:4566
```

### 2. Watch Lambda Logs in Real-Time

```bash
# Get log group name
LOG_GROUP=$(terraform output -raw lambda_log_group_name)

# Tail logs (LocalStack CLI)
aws logs tail $LOG_GROUP --follow \
  --endpoint-url http://localhost:4566
```

Or use the provided script:

```bash
cd scripts
chmod +x watch_logs.sh
./watch_logs.sh
```

### 3. Check Processed Images

```bash
# Get processed bucket name
PROCESSED_BUCKET=$(terraform output -raw processed_bucket_name)

# List processed images
aws s3 ls s3://$PROCESSED_BUCKET/ --recursive \
  --endpoint-url http://localhost:4566
```

Expected output: 5 variants per uploaded image

- `image_compressed_xxx.jpg` (JPEG 85% quality)
- `image_low_xxx.jpg` (JPEG 60% quality)
- `image_webp_xxx.webp` (WebP format)
- `image_png_xxx.png` (PNG format)
- `image_thumbnail_xxx.jpg` (300x300 thumbnail)

### 4. Download Processed Images (Optional)

```bash
# Download a processed image to verify
aws s3 cp s3://$PROCESSED_BUCKET/image_thumbnail_*.jpg ./downloaded_thumbnail.jpg \
  --endpoint-url http://localhost:4566
```

### 5. View SNS Messages (LocalStack)

LocalStack doesn't send real emails, but you can view SNS messages:

```bash
# List SNS topics
aws sns list-topics --endpoint-url http://localhost:4566

# Get topic ARN from output
TOPIC_ARN="arn:aws:sns:us-east-1:000000000000:image-processor-dev-critical-alerts"

# List messages sent to topic
aws sns list-subscriptions-by-topic --topic-arn $TOPIC_ARN \
  --endpoint-url http://localhost:4566
```

---

## 📊 Monitoring with LocalStack

### CloudWatch Dashboard

CloudWatch is partially supported in LocalStack. To view metrics:

```bash
# List all metrics
aws cloudwatch list-metrics \
  --endpoint-url http://localhost:4566

# Get metric statistics
aws cloudwatch get-metric-statistics \
  --namespace AWS/Lambda \
  --metric-name Invocations \
  --dimensions Name=FunctionName,Value=image-processor-dev-processor \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Sum \
  --endpoint-url http://localhost:4566
```

### CloudWatch Logs

View logs in LocalStack:

```bash
# List log groups
aws logs describe-log-groups \
  --endpoint-url http://localhost:4566

# View log events
aws logs filter-log-events \
  --log-group-name /aws/lambda/image-processor-dev-processor \
  --endpoint-url http://localhost:4566
```

### CloudWatch Alarms

Alarms are created but don't trigger automatically in LocalStack. You can manually test:

```bash
# List alarms
aws cloudwatch describe-alarms \
  --endpoint-url http://localhost:4566

# Set alarm state manually
aws cloudwatch set-alarm-state \
  --alarm-name image-processor-dev-processor-high-error-rate \
  --state-value ALARM \
  --state-reason "Manual test" \
  --endpoint-url http://localhost:4566
```

---

## 🔧 Configuration

### LocalStack Configuration

Edit `terraform/terraform.tfvars`:

```hcl
aws_region      = "us-east-1"
project_name    = "image-processor"
environment     = "dev"

# LocalStack-specific
localstack_endpoint = "http://localhost:4566"

# Optional features
enable_cloudwatch_dashboard = true
enable_no_invocation_alarm  = false
enable_s3_versioning        = true

# Thresholds
error_threshold                   = 3
duration_threshold_ms             = 45000
throttle_threshold                = 5
concurrent_executions_threshold   = 50
```

### Lambda Configuration

```hcl
lambda_timeout     = 60      # Seconds (max 900)
lambda_memory_size = 1024    # MB (128-10240)
log_level          = "DEBUG" # INFO for production, DEBUG for development
log_retention_days = 3       # Keep logs shorter in development
```

---

## 🧪 Testing Alarms

### Trigger Error Manually

```bash
# Create invalid image file
echo "This is not an image" > /tmp/fake-image.jpg

# Upload it to trigger error
aws s3 cp /tmp/fake-image.jpg s3://$UPLOAD_BUCKET/invalid.jpg \
  --endpoint-url http://localhost:4566

# Watch logs
aws logs tail $LOG_GROUP --follow \
  --endpoint-url http://localhost:4566 \
  --filter-pattern ERROR
```

### Generate Load Test

```bash
# Create test script
cat > /tmp/load_test.sh << 'EOF'
#!/bin/bash
UPLOAD_BUCKET=$1
for i in {1..5}; do
  aws s3 cp ../tests/sample_image.jpg s3://$UPLOAD_BUCKET/test-$i.jpg \
    --endpoint-url http://localhost:4566 &
done
wait
echo "Load test completed"
EOF

chmod +x /tmp/load_test.sh
./load_test.sh $UPLOAD_BUCKET
```

---
