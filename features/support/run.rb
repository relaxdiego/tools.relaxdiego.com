def git_path
  # 'tmp/git_repo'
  File.expand_path('../../../test_git_repo', __FILE__)
end

def init_git_repo
  `rm -rf #{git_path} && mkdir #{git_path}`
end

def run(command)
  `cd #{git_path} && #{command}`
end