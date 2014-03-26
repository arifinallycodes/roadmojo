# devise-async supports various gems for background-jobs to make it compatible with
# the devise gem used for authentication. This initializer is to tell the Devise::Async of which 
# gem are we using for background jobs.

# Once we move out of Heroku, uncomment the below line
Devise::Async.backend = :delayed_job