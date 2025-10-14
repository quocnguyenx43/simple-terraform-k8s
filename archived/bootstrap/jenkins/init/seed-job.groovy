import jenkins.model.*
import org.jenkinsci.plugins.workflow.job.*

def jenkins = Jenkins.instance

def jobs = [
    [name: "connection-test", path: "pipelines/connection-test.Jenkinsfile", desc: "Test Git & Docker connection"],
    [name: "build-app", path: "pipelines/build-app.Jenkinsfile", desc: "Build & push Docker image"],
    [name: "deploy-app", path: "pipelines/deploy-app.Jenkinsfile", desc: "Deploy container"]
]

jobs.each { j ->
    if (jenkins.getItem(j.name) == null) {
        def job = new WorkflowJob(jenkins, j.name)
        job.setDescription(j.desc)
        job.definition = new org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition(
            new File("/var/jenkins_home/${j.path}").text, true
        )
        jenkins.add(job, j.name)
        println("Created job: ${j.name}")
    } else {
        println("Job already exists: ${j.name}")
    }
}
jenkins.save()
