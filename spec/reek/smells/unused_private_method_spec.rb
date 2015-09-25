require_relative '../../spec_helper'
require_lib 'reek/smells/unused_private_method'
require_relative 'smell_detector_shared'

RSpec.describe Reek::Smells::UnusedPrivateMethod do
  let(:detector) { build(:smell_detector, smell_type: :UnusedPrivateMethod) }

  it_should_behave_like 'SmellDetector'

  describe 'examine_context' do
    xit 'reports unused private instance methods' do
      source = <<-EOF
        class Klazz
          private
          def foo; end
        end
      EOF

      expect(source).to reek_of(:UnusedPrivateMethod, name: 'Klazz#foo')
    end

    xit 'reports unused private class methods' do
      source = <<-EOF
        class Klazz
          class << self
            private
            def foo; end
          end
        end
      EOF

      expect(source).to reek_of(:UnusedPrivateMethod,
                                name: 'Klazz.foo')
    end

    it 'does not report methods that are called' do
      source = <<-EOF
        class Klazz
          def public_method
            foo
          end

          private
          def foo; end
        end
      EOF

      expect(source).not_to reek_of(:UnusedPrivateMethod)
    end

    xit 'discerns between class and instance methods' do
      source = <<-EOF
        class Klazz
          def public_method
            foo
          end

          class << self
            private
            def foo; end
          end

          private
          def foo; end
        end
      EOF

      expect(source).to reek_of(:UnusedPrivateMethod,
                                name: 'Klazz.foo')

      expect(source).not_to reek_of(:UnusedPrivateMethod,
                                    name: 'Klazz#foo')
    end

    xit 'creates warnings correctly' do
      source = <<-EOF
        class Klazz
          class << self
            private
            def foo; end
          end

          private

          def bar; end
        end
      EOF

      ctx = create_context(source)
      warnings = detector.examine_context(ctx)
      first_warning = warnings.first
      expect(first_warning.smell_category).to eq(Reek::Smells::UnusedPrivateMethod.smell_category)
      expect(first_warning.smell_type).to eq(Reek::Smells::UnusedPrivateMethod.smell_type)
      expect(first_warning.parameters[:name]).to eq('Klazz.foo')
      expect(first_warning.lines).to eq([4])

      second_warning = warnings.last
      expect(second_warning.smell_category).to eq(Reek::Smells::UnusedPrivateMethod.smell_category)
      expect(second_warning.smell_type).to eq(Reek::Smells::UnusedPrivateMethod.smell_type)
      expect(second_warning.parameters[:name]).to eq('Klazz#bar')
      expect(second_warning.lines).to eq([9])
    end
  end
end
