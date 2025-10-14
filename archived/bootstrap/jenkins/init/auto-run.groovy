import jenkins.model.*
import hudson.model.*

def jenkins = Jenkins.instance

def job1 = "connection-test"
def job2 = "build-app"
def job3 = "deploy-app"

// job1
def build1 = jenkins.getItem(job1)?.scheduleBuild2(0)?.get()
println "${job1} completed with result: ${build1?.getResult()}"

// if job1 succeeded, then trigger job2
if (build1?.getResult() == Result.SUCCESS) {
    def build2 = jenkins.getItem(job2)?.scheduleBuild2(0)?.get()
    println "${job2} completed with result: ${build2?.getResult()}"

    // if job2 succeeded, then trigger job3
    if (build2?.getResult() == Result.SUCCESS) {
        def build3 = jenkins.getItem(job3)?.scheduleBuild2(0)?.get()
        println "${job3} completed with result: ${build3?.getResult()}"
    }
    else {
        println "Skipping ${job3}, ${job2} failed."
    }
}
else {
    println "Skipping ${job2} and ${job3}, ${job1} failed."
}
