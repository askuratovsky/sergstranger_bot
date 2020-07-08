deploy:
	ssh `cat config/config.yaml | grep deploy_to | sed 's/deploy_to:[ ]*\(.*\)/\1/g' | sed -e 's/["'\'']//g'` \
	 'source .bash_profile && cd sergstranger_bot && git pull && bundle install && bin/bot.rb restart'
