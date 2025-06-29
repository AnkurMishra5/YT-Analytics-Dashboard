provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "youtube" {
  bucket = var.s3_bucket
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-role"
  assume_role_policy = file("iam-role.json")
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "youtube_fetch" {
  function_name = "youtube-data-fetcher"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  filename      = "../lambda/lambda.zip"
  environment {
    variables = {
      YOUTUBE_API_KEY = var.youtube_api_key
      CHANNEL_ID      = var.channel_id
      S3_BUCKET_NAME  = var.s3_bucket
    }
  }
}

resource "aws_cloudwatch_event_rule" "trigger" {
  name                = "every-6h"
  schedule_expression = "rate(6 hours)"
}

resource "aws_cloudwatch_event_target" "target" {
  rule = aws_cloudwatch_event_rule.trigger.name
  arn  = aws_lambda_function.youtube_fetch.arn
}

resource "aws_lambda_permission" "allow" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.youtube_fetch.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.trigger.arn
}

resource "aws_security_group" "grafana_sg" {
  name = "grafana-sg"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "grafana" {
  ami           = "ami-0c2b8ca1dad447f8a" # Amazon Linux 2
  instance_type = "t2.micro"
  key_name      = var.key_pair_name
  security_groups = [aws_security_group.grafana_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y amazon-linux-extras
              sudo amazon-linux-extras enable epel
              sudo yum install -y grafana
              sudo systemctl enable grafana-server
              sudo systemctl start grafana-server
              EOF
}