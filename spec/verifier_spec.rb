# require 'tempfile'
# require_relative '../lib/verifier'

# describe 'Verifier throws error when file cannot be read' do
#   def vrf_file(file)
#     Verifier.check_file(file)
#   end

#   before do
#     $stdout = StringIO.new
#     $stderr = StringIO.new
#   end
#   after(:all) do
#     $stdout = STDOUT
#     $stderr = STDERR
#   end

#   it 'when file not found' do
#     message = 'File does not exist: fakefile'
#     expect { vrf_file }.to \
#       raise_exception(SystemExit, message)
#   end

#   it 'when file is not readable' do
#     test_file = Tempfile.new('fakefile')
#     message = "File is not readable: #{test_file.path}"
#     test_file.chmod(000)
#     expect { Verifier.check_file(test_file.path) }.to \
#       raise_exception(SystemExit, message)
#   end
# end
