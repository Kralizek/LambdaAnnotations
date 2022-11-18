module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name                     = "find-nationality"
  description                       = "Find the most probable nationalities for any given name"
  handler                           = "FindNationalityFunction::FindNationalityFunction.Functions_GetCountriesAsync_Generated::GetCountriesAsync"
  runtime                           = "dotnet6"
  memory_size                       = 128
  timeout                           = 30
  cloudwatch_logs_retention_in_days = 3
  create_package                    = false
  local_existing_package            = "../src/FindNationalityFunction/bin/Release/net6.0/FindNationalityFunction.zip"
  tags = {
    Name = "find-nationality"
  }
  depends_on = [
    null_resource.package
  ]
}

resource "null_resource" "package" {
  provisioner "local-exec" {
    command     = "dotnet lambda package"
    working_dir = "../src/FindNationalityFunction"
    interpreter = ["PowerShell", "-Command"]
  }
}