pipeline {
    agent any
    
parameters {
        string(name: 'terraform_path', defaultValue: 'terraform', description: 'Enter a terraform path, like terraform/test')
  }
    stages {

     stage("Terraform Init") {
        when {
          expression {
              env.BRANCH_NAME == "dev" || env.BRANCH_NAME == "master"
          }
       }

        steps {
            script {
            def tfHome = tool name: 'Terraform'
            env.PATH = "${tfHome}:${env.PATH}"
            
            echo 'terraform init'
           // sh "${env.TERRAFORM_HOME}/terraform init terraform/"
                terraformAction("init")
              //sh "terraform init $terraform_path/"
        }
        }
   }
       stage("Terraform Validate") {

         steps {
              echo "terraform validate"
             terraformAction("validate")
             //sh "terraform validate $terraform_path/"
        }
}
        stage("Terraform Plan") {

          steps {
                echo "terraform plan"
              terraformAction("plan")
             // sh "terraform plan $terraform_path/"
         }
}
         stage("Terraform Apply") {

           steps {
              echo "terraform apply"
               terraformAction("apply -auto-approve")
               //sh "terraform apply -auto-approve $terraform_path/"
          }
     }
  }
}

def terraformAction(String tfAction){
    if (tfAction == "init")
    echo "Hello World"
    sh "terraform ${tfAction} $terraform_path/"
}
