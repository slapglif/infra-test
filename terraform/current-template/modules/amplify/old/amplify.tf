resource "aws_iam_role" "amplify_role" {
  name               = "amplify_deploy_terraform_role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "amplify.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "amplify_role_policy" {
  name   = "amplify_iam_role_policy"
  role   = aws_iam_role.amplify_role.id
  policy = var.amplify_role_policies_file_path
}

data "external" "bitbucket_oauth_token" {
  program = ["bash", "scripts/generate_bitbucket_oauth_token.sh"]
}

resource "aws_amplify_app" "my-music-auto" {
  name                        = var.amplify_app_name
  repository                  = "https://bitbucket.org/dotmusic/id.music.git"
  platform                    = "WEB_COMPUTE"
  oauth_token                 = data.external.bitbucket_oauth_token.result.oauth_token
  build_spec                  = var.amplify_build_spec_file_path
  enable_branch_auto_build    = true
  enable_auto_branch_creation = true

  auto_branch_creation_patterns = [
    "*"
  ]
  enable_branch_auto_deletion = true

  iam_service_role_arn = aws_iam_role.amplify_role.arn
  environment_variables = {
    "AMPLIFY_MONOREPO_APP_ROOT" = "id-music-front"
  }
}

resource "aws_amplify_branch" "dev" {
  app_id                      = aws_amplify_app.my-music-auto.id
  branch_name                 = "dev"
  stage                       = "DEVELOPMENT"
  enable_auto_build           = true
  enable_pull_request_preview = true
  framework                   = "Next.js - SSR"

  environment_variables = {
    "ANY_USEFUL_VAR" = "value1"
  }
}

resource "aws_amplify_backend_environment" "my-music-auto" {
  app_id           = aws_amplify_app.my-music-auto.id
  environment_name = "dev"
}

resource "aws_amplify_branch" "master" {
  app_id                      = aws_amplify_app.my-music-auto.id
  branch_name                 = "master"
  stage                       = "PRODUCTION"
  enable_auto_build           = true
  enable_pull_request_preview = true
  framework                   = "Next.js - SSR"

  environment_variables = {
    "ANY_USEFUL_VAR" = "example"
  }
}
