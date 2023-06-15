
resource "aws_lambda_function" "web_lambda_function" {
  filename = "web_lambda_function.zip"
  function_name = "web_lambda_function"
  role = aws_iam_role.lambda_role.arn
  handler = "index.handler"
  runtime = "nodejs14.x"
  timeout = 10
  memory_size = 128
  environment {
    variables = {
      DB_HOST = aws_db_instance.web_db_instance.address
      DB_NAME = var.db_name
      DB_USER = var.db_username
      DB_PASSWORD = var.db_password
    }
  }
}

resource "aws_lambda_layer_version" "web_lambda_layer" {
  filename = "web_lambda_layer.zip"
  layer_name = "web_lambda_layer"
  compatible_runtimes = ["nodejs14.x"]
}

resource "aws_lambda_permission" "web_lambda_permission" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.web_lambda_function.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = aws_api_gateway_deployment.web_api_gateway_deployment.execution_arn
}

resource "aws_lambda_function" "web_lambda_function" {
  function_name = "web_lambda_function"
  role = aws_iam_role.web_lambda_role.arn
  handler = "app.lambda_handler"
  runtime = "python3.8"
  filename = "${path.module}/app.zip"
  source_code_hash = filebase64sha256("${path.module}/app.zip")
}

resource "aws_iam_role" "web_lambda_role" {
  name = "web_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "web_lambda_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.web_lambda_role.name
}

resource "aws_lambda_function" "web_lambda_function" {
  filename      = "${path.module}/web_lambda_function.zip"
  function_name = "web_lambda_function"
  role          = aws_iam_role.web_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
}
