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
            echo 'terraform init'
            sh "terraform init terraform/"
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
         }
}
         stage("apply") {

           steps {
              echo "terraform apply"
          }
     }
  }
}
