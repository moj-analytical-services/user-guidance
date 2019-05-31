require 'govuk_tech_docs'

GovukTechDocs.configure(self)

activate :deploy do |deploy|
    deploy.deploy_method = :git
    # Optional Settings
    # deploy.remote   = 'custom-remote' # remote name or git url, default: origin
    # deploy.branch   = 'custom-branch' # default: gh-pages
    # deploy.strategy = :submodule      # commit strategy: can be :force_push or :submodule, default: :force_push
    # deploy.commit_message = 'custom-message'      # commit message (can be empty), default: Automated commit at `timestamp` by middleman-deploy `version`
  end