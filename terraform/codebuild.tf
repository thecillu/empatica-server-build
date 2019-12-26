resource "aws_ecr_repository" "empatica-registry" {
  name = var.ecr_name
} 

resource "aws_iam_role" "empatica-role" {
  name = "empatica-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "empatica-policy" {
  role = aws_iam_role.empatica-role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ecr:GetAuthorizationToken",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecs:RunTask",
        "iam:PassRole"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "empatica-build" {
  name          = "empatica-server-build"
  description   = "build job for empatica server"
  build_timeout = "5"
  service_role  = aws_iam_role.empatica-role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }


  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:2.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true

     environment_variable {
      name  = "REPOSITORY_URI"
      value = aws_ecr_repository.empatica-registry.repository_url
    }

     environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }

  }

  source {
    type            = "GITHUB"
    location        = var.github_url
    git_clone_depth = 1
  }

}

