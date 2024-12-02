#!/bin/bash

# Input 파일 (raw taxonomy 파일)
input_file="UNITE_public_taxonomy_modi_21.04.2024.txt"

# Output 파일
output_file="UNITE_public_taxonomy_modi2_21.04.2024.txt"

# 헤더 추가 및 데이터 
{
  echo -e "Feature ID\tTaxon" # 헤더 추가
  awk -F'\|' '{taxon=$2; sub("\\|.*", "", taxon); print $0 "\t" taxon}' "$input_file"
} > "$output_file"

echo "파일이 성공적으로 생성되었습니다: $output_file"
코드 설명

echo "파일이 성공적으로 생성되었습니다: $output_file"
