require 'chefspec'

# Describing our custom resource.
describe 'bareos_graphite_plugin' do
  # Normally ChefSpec skips running resources, but for this test we want to
  # actually run this one custom resource.
  step_into :bareos_graphite_plugin
  # Nothing in this test is platform-specific, so use the latest Ubuntu for
  # simulated data.
  platform 'ubuntu'

  # Create an example group for testing the resource defaults.
  context 'with the default greeting' do
    # Set the subject of this example group to a snippet of recipe code calling
    # our custom resource.
    recipe do
      bareos_graphite_plugin 'test'
    end

    # Confirm that the resources created by our custom resource's action are
    # correct. ChefSpec matchers all take the form `action_type(name)`.
    # it { is_expected.to write_log('Hello world') }
  end

  # Create a second example group to test a different block of recipe code.
  context 'with a custom greeting' do
    # This time our test recipe code sets a property on the custom resource.
    recipe do
      bareos_graphite_plugin 'test' do
        # greeting 'Bonjour'
      end
    end

    # Use the same kind of matcher as before to confirm the action worked.
    # it { is_expected.to write_log('Bonjour world') }
  end
end
