require 'govuk_tech_docs'

GovukTechDocs.configure(self)

set :site_url, ""

configure :build do
    set :http_prefix, '/user-guidance'
end
