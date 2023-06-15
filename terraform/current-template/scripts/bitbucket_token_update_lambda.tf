data "archive_file" "oauth_token_update_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/index.js"
  output_path = "${path.module}/oauth_token_update_lambda_function.zip"
}

resource "aws_lambda_function" "oauth_token_update_lambda" {
  function_name    = "bitbucket-oauth-token-update-lambda"
  runtime          = "nodejs16.x"
  handler          = "index.handler"
  role             = aws_iam_role.lambda_role.arn
  timeout          = 60
  filename         = "${path.module}/oauth_token_update_lambda_function.zip"
  source_code_hash = data.archive_file.oauth_token_update_lambda_zip.output_base64sha256

  # Environment variables for Bitbucket credentials
  environment {
    variables = {
      CLIENT_ID      = var.amplify_bitbucket_client_id
      CLIENT_SECRET  = var.amplify_bitbucket_client_secret
      REPO_NAME      = "id.music"
      ORG_NAME       = "dotmusic"
      AMPLIFY_APP_ID = aws_amplify_app.my-music-auto.id
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"
  # Attach necessary permissions for the Lambda function
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
}
EOF

  # Attach the necessary policies to the role
  # Adjust the policies based on your requirements
  inline_policy {
    name   = "lambda-policy"
    policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "amplify:UpdateApp"
          ],
          "Resource": "*"
        }
      ]
    }
EOF
  }
}

resource "aws_cloudwatch_event_rule" "bitbucket_token_update_lambda_schedule" {
  name                = "bitbucket-token-update-lambda-schedule-rule"
  description         = "Schedule rule for triggering Lambda function"
  schedule_expression = "rate(60 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.bitbucket_token_update_lambda_schedule.name
  target_id = "bitbucket-oauth-token-update-lambda"
  arn       = aws_lambda_function.oauth_token_update_lambda.arn
}

resource "aws_lambda_permission" "event_permission" {
  statement_id  = "AllowExecutionFromCloudWatchEvents"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.oauth_token_update_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.bitbucket_token_update_lambda_schedule.arn
}
