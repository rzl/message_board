package MyApp;
use Mojo::Base 'Mojolicious';
use MyApp::Model::DB;
use MyApp::Model::Users;
use MyApp::Model::Entries;

# This method will run once at server start
sub startup {
  my $app = shift;
  $app->app->secrets(['message_board']);
  
#load helper
  $app->helper(DB => sub { state $appDB = MyApp::Model::DB->new });
  $app->helper(users => sub {state $users = MyApp::Model::Users->new});
  $app->helper(entries => sub {state $entries = MyApp::Model::Entries->new}); 
  
#load web db conf
  if (-e 'conf/db.conf'){
	  $app->helper(db_conf => sub {$app->plugin('Config', {file => 'conf/db.conf'})});
	  say $app->db_conf->{db_name};
		if (-e  $app->db_conf->{db_name} ){
			$app->DB->db_name($app->db_conf->{db_name});
			$app->DB->connect_db;
#conf helper dbh
			$app->users->dbh($app->DB->dbh);
			$app->entries->dbh($app->DB->dbh);
		} else {
			say $app->db_conf->{db_name}." db file not exist";
			say "please run http://localhost:3000/install";
		}
  } else {
	say 'conf file not found';
	say "please run http://localhost:3000/install";
	
  }
  
  
  
  # Documentation browser under "/perldoc"
  $app->plugin('PODRenderer');
  
  # Router
  my $r = $app->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
  $r->get('/index')->to('example#index');
  $r->get('/publish')->to('example#publish');
  $r->post('/publish')->to('Postpage#publish');
  $r->get('/login')->to('example#login');
  $r->post('/login')->to('Postpage#login');
  $r->get('/logout')->to('example#logout');
  $r->get('/register')->to('example#register');
  $r->post('/register')->to('Postpage#register');
  $r->get('/del')->to('example#del');
  $r->any('/install')->to('install#setpone');
  $r->get('/users')->to('example#user');
  $r->get('/pages/:pid')->to('example#pages');
  
}

1;
