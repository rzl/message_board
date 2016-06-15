package MyApp::Controller::Postpage;
use Mojo::Base 'Mojolicious::Controller';

sub login {
  my $c = shift;
  my $aurl=$c->req->headers->referrer;
  $aurl=~s/http.+\//\//;
  if ($c->session->{name}){
  $c->render(msg => $aurl);
  } else {
	my $username=$c->param('username');
	my $password=$c->param('password');
	  if ($c->users->check_user_pass($username,$password)){
	  $c->session->{name}=$username;
	  $c->render(msg => $aurl);
	  } else {
	  $c->render(msg => $aurl);
	  } 
	 
}
}

sub publish{
    my $c = shift;
   
   $c->Entries->add_entries();
	
}

sub register{
	my $self = shift;
	my $username=$self->param('username');
	my $password=$self->param('password');
	if ($self->users->isuser($username)){
	$self->render(msg => '账号已存在');
	} else {
	my $dbh = $self->AppDB->getcon();
    my $sql = 'insert into users (name, password) values (?, ?)';
    my $sth = $dbh->prepare($sql) or die $dbh->errstr;
    $sth->execute($self->param('username'), $self->param('password'))or die $sth->errstr;
	$self->render(msg => '注册成功');
	$self->AppDB->putcon($dbh); 
	}
	
}

sub del{
	my $self = shift;
	
}
1;









