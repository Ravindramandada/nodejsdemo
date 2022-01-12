resource "aws_codepipeline" "pipeline" {
  name     = "${var.cluster_name}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.source.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        ConnectionArn    = "arn:aws:codestar-connections:us-east-1:870597747842:connection/208937cb-4060-4b42-b1e1-bdd2505e822c"
        FullRepositoryId  = var.git_repository["name"]
        BranchName  = var.git_repository["branch"]
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["imagedefinitions"]

      configuration = {
        ProjectName = "${var.cluster_name}-codebuild"
      }
    }
  }

  stage {
    name = "Production"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["imagedefinitions"]
      version         = "1"

      configuration = {
        ClusterName = var.cluster_name
        ServiceName = var.app_service_name
        FileName    = "imagedefinitions.json"
      }
    }
  }
}

