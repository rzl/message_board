package MyApp::Controller::Install;
use Mojo::Base 'Mojolicious::Controller';

sub setpone{
  my $c = shift;
  my $msg='nothing';
   -w 'conf/db.conf' ? $msg='db file can not write': $msg='db file can write';
  $c->stash(msg => $msg);

  if (defined($c->param('install'))){
  my $db_name=$c->param('db_dbname');
  if (-e $db_name.'.db' )
  { $msg='dbfile is exist , install stop' ;
	$c->render('install\error',msg=>$msg);
  }
  else
  { $msg='dbfile is not exist';
  $c->DB->create_dbfile($db_name);
  open FH,'>conf/db.conf';
  say FH '{';
  say FH "db_name => \'$db_name\.db\'";
  say FH '};';
  close FH;
  my $admin_name=$c->param('db_user');
  my $admin_password=$c->param('db_pass');

  my $sql = 'insert into users (name, password,tid) values (?,?,?)';
  my $sth = $c->DB->dbh->prepare($sql) or die $c->DB->dbh->errstr;
    $sth->execute(
		$c->param('db_user'),
		$c->param('db_pass'),
		'1'
		)or die $sth->errstr;
  $c->app->routes->find('*')->remove;
  $c->render('install\error',msg=> 'install all done');
  
  };
  } else {
  $c->render;
 
  }

}


1;