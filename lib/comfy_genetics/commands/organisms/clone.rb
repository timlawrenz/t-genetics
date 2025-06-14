# frozen_string_literal: true

module ComfyGenetics
  module Organisms
    class Clone < GLCommand::Callable # TODO: GLCommand
      requires organism: Organism, # TODO: ComfyGenetics::Organism
               target_generation: Generation # TODO: ComfyGenetics::Generation
      returns dolly_clone: Organism # TODO: ComfyGenetics::Organism

      def call
        # 1. Create the basic clone structure using Organisms::Create command
        # TODO: ComfyGenetics::Organisms::Create, ComfyGenetics::Generation
        create_result = Organisms::Create.call(generation: context.target_generation)
        unless create_result.success?
          fail_command!(errors: create_result.errors)
          return
        end
        context.dolly_clone = create_result.organism

        # 2. Copy direct attributes from the original organism to the clone
        context.dolly_clone.fitness = context.organism.fitness

        # 3. Save the clone to persist attributes like fitness.
        #    save! will raise an error if validations fail, which GLCommand handles.
        context.dolly_clone.save!

        # 4. Copy values from the original organism to the clone
        # TODO: ComfyGenetics::Organism
        context.organism.values.each do |original_value|
          # Organism#set_value calls Organisms::SetValue.call(...), which returns a GLCommand::Context.
          # TODO: ComfyGenetics::Organism, ComfyGenetics::Organisms::SetValue
          set_value_context = context.dolly_clone.set_value(original_value.name, original_value.data)

          # Check if the Organisms::SetValue command was successful.
          unless set_value_context.success?
            # If Organisms::SetValue failed, propagate its errors and fail the Clone command.
            fail_command!(errors: set_value_context.errors)
            return # Stop processing further values and exit.
          end
        end

        # 5. Reload the dolly_clone to ensure the returned object has the latest persisted state.
        context.dolly_clone.reload
      end
    end
  end
end
