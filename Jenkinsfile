pipeline {
    agent any
    
   // parameters {
   //     choice(name: 'refresh_parameters', choices: "Yes\nNo", description: "Do you wish to do a dry run to load dynamic parameters?")
     //   choice(name: 'stage', choices: 'qa\nprod', description: "Select a stage to deploy")
       // string(name: 'terraform_path', defaultValue: '', description: 'Enter a terraform path, like terraform/domains/product_line/global_product_line/curated/source/producer')
        //choice(name: 'terraformAction', choices: "init\nvalidate\napply\ndestroy", description: "Select a terraform action (A manual confirmation is required before performing any action)")
    //}

    stages {

      stage("init") {
        when {
          expression {
              env.BRANCH_NAME == "dev" || env.BRANCH_NAME == "master"
          }
        }

        steps {
            echo 'terraform init'
            echo '${env.TERRAFORM_HOME}'
            sh "${env.TERRAFORM_HOME}/terraform init -input=false"
        }
   }
       stage("validate") {

         steps {
              echo "terraform validate"
             sh "${env.TERRAFORM_HOME}/terraform validate -input=false"
        }
}
        stage("plan") {

          steps {
                echo "terraform plan"
              sh "${env.TERRAFORM_HOME}/terraform plan -out=tfplan -input=false"
         }
}
         stage("apply") {

           steps {
              echo "terraform apply"
          }
     }
  }
}
