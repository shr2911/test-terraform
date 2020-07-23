pipeline {
    agent any

    stages {

      stage("init") {
        when {
          expression {
              env.BRANCH_NAME = "dev" || env.BRANCH_NAME = "master"
          }
        }

        steps {
            echo 'terraform init'
       }
   }
       stage("validate") {

         steps {
              echo "terraform validate"
        }
}
        stage("plan") {

          steps {
                echo "terraform plan"
         }
}
         stage("apply") {

           steps {
              echo "terraform apply"
          }
     }
  }
  post {
    always {

     }
    success {

    }
    failure {


    }
  }
}
