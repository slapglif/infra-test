
resource "aws_api_gateway_rest_api" "web_api_gateway" {
  name = "web_api_gateway"
}

resource "aws_api_gateway_resource" "web_api_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.web_api_gateway.id
  parent_id = aws_api_gateway_rest_api.web_api_gateway.root_resource_id
  path_part = "web"
}

resource "aws_api_gateway_method" "web_api_gateway_method" {
  rest_api_id = aws_api_gateway_rest_api.web_api_gateway.id
  resource_id = aws_api_gateway_resource.web_api_gateway_resource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "web_api_gateway_integration" {
  rest_api_id = aws_api_gateway_rest_api.web_api_gateway.id
  resource_id = aws_api_gateway_resource.web_api_gateway_resource.id
  http_method = aws_api_gateway_method.web_api_gateway_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.web_lambda_function.invoke_arn
}

resource "aws_api_gateway_deployment" "web_api_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.web_api_gateway.id
  stage_name = "dev"
}
