pipeline {
    agent any
    

    stages {

      stage("init") {
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
//            echo "${env.TERRAFORM_HOME}"
           // sh "${env.TERRAFORM_HOME}/terraform init terraform/"
              sh "terraform init terraform/"
        }
        }
   }
       stage("validate") {

         steps {
              echo "terraform validate"
             sh "terraform validate terraform/"
        }
}
        stage("plan") {

          steps {
                echo "terraform plan"
              sh "terraform plan terraform/"
         }
}
         stage("apply") {

           steps {
              echo "terraform apply"
               sh "terraform apply -auto-approve terraform/"
          }
     }
  }
}
