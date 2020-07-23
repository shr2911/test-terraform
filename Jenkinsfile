pipeline {
    agent any

    stages {

      stage("init") {

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
}
