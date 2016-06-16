package MyApp;
use Mojo::Base 'Mojolicious';
use MyApp::Model::DB;
use MyApp::Model::Users;
use MyApp::Model::Entries;

# This method will run once at server start
sub startup {
  my $c = shift;
  $c->app->secrets(['message_board']);
  
#load helper
  $c->helper(DB => sub { state $appDB = MyApp::Model::DB->new });
  $c->helper(users => sub {state $users = MyApp::Model::Users->new});
  $c->helper(entries => sub {state $entries = MyApp::Model::Entries->new}); 
  
#load web db conf
  if (-e 'conf/db.conf'){
	  $c->helper(db_conf => sub {$c->plugin('Config', {file => 'conf/db.conf'})});
	  say $c->db_conf->{db_name};
		if (-e  $c->db_conf->{db_name} ){
			$c->DB->db_name($c->db_conf->{db_name});
			$c->DB->connect_db;
			$c->users->dbh($c->DB->dbh);
			$c->entries->dbh($c->DB->dbh);
		} else {
			say $c->db_conf->{db_name}." db file not exist";
			say "please run http://localhost:3000/install";
		}
  }
  
  
  
  # Documentation browser under "/perldoc"
  $c->plugin('PODRenderer');
  
  # Router
  my $r = $c->routes;

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
