require 'rugged'
require 'dotenv'
Dotenv.load

# From https://coderwall.com/p/l9xxaq/commit-a-new-file-to-git-using-rugged

git_email = 'erik@erikschwartz.net'
git_name = 'Erik Schwartz'

# # (1)
dir = Dir.mktmpdir
clone_url = 'https://github.com/eeeschwartz/target-repo-for-rugged.git'
repo = Rugged::Repository.clone_at(clone_url, dir)

#
# (2)
repo.checkout 'refs/heads/master'

# (3)
index = repo.index

# (4)
File.unlink File.join(repo.workdir, 'README.md')
index.remove 'README.md'

# (5)
File.open File.join(repo.workdir, 'README.adoc'), 'w' do |f|
  f.write %(= README\n\nNew readme.)
end
index.add path: 'README.adoc',
  oid: (Rugged::Blob.from_workdir repo, 'README.adoc'),
  mode: 0100644

# (6)
commit_tree = index.write_tree repo

# (7)
index.write

# (8)
commit_author = { email: git_email, name: git_name, time: Time.now }
Rugged::Commit.create repo,
  author: commit_author,
  committer: commit_author,
  message: 'Adding README from the rugged gem',
  parents: [repo.head.target],
  tree: commit_tree,
  update_ref: 'HEAD'

user = ENV['GITHUB_USER']
pass = ENV['GITHUB_PASS']

credentials = Rugged::Credentials::UserPassword.new(username: user, password: pass)

repo.push('origin', ['refs/heads/master'], { credentials: credentials })

