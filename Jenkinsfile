pipeline {
    agent any
    
parameters {
        string(name: 'terraform_path', defaultValue: 'terraform', description: 'Enter a terraform path, like terraform')
    }
    stages {

      stage("Terraform init") {
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
       stage("Terraform validate") {

         steps {
              echo "terraform validate"
             terraformAction("validate")
             //sh "terraform validate $terraform_path/"
        }
}
        stage("Terraform plan") {

          steps {
                echo "terraform plan"
              terraformAction("plan")
             // sh "terraform plan $terraform_path/"
         }
}
         stage("Terraform apply") {

           steps {
              echo "terraform apply"
               terraformAction("apply -auto-approve")
               //sh "terraform apply -auto-approve $terraform_path/"
          }
     }
  }
}

def terraformAction(String tfAction){
    //sh "sh /epctl-setup.sh"
    sh "terraform ${tfAction} ${terraform_path}/"
}
