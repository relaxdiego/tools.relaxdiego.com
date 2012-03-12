def create_commits(array_of_commit_messages)
  array_of_commit_messages.reverse.each do |commit|
    run "touch 'file.txt'"
    run "echo '#{commit[:commit_message]}' >> file.txt"
    run "git add ."
    run "git commit -m '#{commit[:commit_message]}'"
  end
end