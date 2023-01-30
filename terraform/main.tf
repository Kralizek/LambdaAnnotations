locals { 
  functions = {
    for key, value in jsondecode(file("${path.module}/../src/FindNationalityFunction/serverless.template")).Resources : key => value
      if value.Type == "AWS::Serverless::Function" && value.Properties.PackageType == "Zip"
  }
}

resource "null_resource" "package" {
  provisioner "local-exec" {
    command     = "dotnet lambda package"
    working_dir = "../src/FindNationalityFunction"
    interpreter = ["PowerShell", "-Command"]
  }
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"
  for_each = local.functions

  function_name = each.key
  handler = each.value.Properties.Handler
  runtime = each.value.Properties.Runtime
  memory_size = each.value.Properties.MemorySize
  timeout = each.value.Properties.Timeout
  cloudwatch_logs_retention_in_days = 3
  create_package = false
  local_existing_package = "../src/FindNationalityFunction/bin/Release/net6.0/FindNationalityFunction.zip"
  tags = {
    Name = each.key
  }
  depends_on = [
    null_resource.package
  ]
}