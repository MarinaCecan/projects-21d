#!groovy

import jenkins.model.*
import hudson.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

// Create a local user accounts
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount('admin','password')
hudsonRealm.createAccount('ro_user','ro_pass')
instance.setSecurityRealm(hudsonRealm)

// Setup permissions
// See https://gist.github.com/jnbnyc/c6213d3d12c8f848a385
def strategy = new GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.READ, "ro_user")
strategy.add(hudson.model.Item.READ, "ro_user")


// Setting Admin Permissions
strategy.add(Jenkins.ADMINISTER, "admin")

instance.setAuthorizationStrategy(strategy)
instance.save()
