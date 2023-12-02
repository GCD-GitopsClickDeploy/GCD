#!/bin/bash

# EKS 클러스터 이름 설정
CLUSTER_NAME="gcd-eks"

# EKS 클러스터의 첫 번째 워커 노드(즉, EC2 인스턴스) ID를 가져옵니다
INSTANCE_ID=$(aws ec2 describe-instances \
    --query "Reservations[*].Instances[0].InstanceId" \
    --filters "Name=tag:kubernetes.io/cluster/$CLUSTER_NAME,Values=owned" "Name=instance-state-name,Values=running" \
    --output text)

echo "Instance ID: $INSTANCE_ID"

# 인스턴스의 첫 번째 보안 그룹 ID를 조회합니다
SECURITY_GROUP_ID=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query "Reservations[0].Instances[0].SecurityGroups[0].GroupId" \
    --output text)

echo "Security Group ID: $SECURITY_GROUP_ID"

# 추가할 보안 규칙 설정
PROTOCOL="tcp"
PORTS=("30148" "30080")
CIDR="0.0.0.0/0"

# 보안 그룹에 각 포트에 대한 규칙 추가
for PORT in "${PORTS[@]}"
do
    echo "Adding ingress rule for port $PORT to Security Group ID: $SECURITY_GROUP_ID"
    aws ec2 authorize-security-group-ingress \
        --group-id "$SECURITY_GROUP_ID" \
        --protocol $PROTOCOL \
        --port $PORT \
        --cidr $CIDR
done
