# frozen_string_literal: true

module ComfyGenetics
  class Comfy < GLCommand::Callable # TODO: GLCommand might need namespacing or be a different gem
    requires :organisms # TODO: ComfyGenetics::Organism

    def call
      organisms.each do |organism| # TODO: ComfyGenetics::Organism
        payload = ApplicationController.renderer.render template: 'application/workflow_api', # TODO: This might be an issue if ApplicationController is part of the main app
                                                        assigns: { o: organism.to_hsh, organism: }
        Net::HTTP.post(uri, payload, { 'Content-Type': 'application/json' })
      end
    end

    private

    def uri
      URI('http://localhost:8188/prompt')
    end
  end
end
