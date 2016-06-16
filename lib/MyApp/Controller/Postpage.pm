package MyApp::Controller::Postpage;
use Mojo::Base 'Mojolicious::Controller';

sub login {
  my $c = shift;
  my $aurl=$c->req->headers->referrer;
  $aurl=~s/http.+\//\//;
  $c->stash(aurl => $aurl);
  #$c->stash(msg => '登录失败，请检测帐号密码');
  
  if ($c->session->{name}){
  $c->render(aurl => $aurl);
  } else {
	my $username=$c->param('username');
	my $password=$c->param('password');
	  if ($c->users->check_user_pass($username,$password)){
	  $c->session->{name}=$username;
	  $c->render(msg => '登录成功');
	  } else {
	  $c->render(msg => '登录失败，请检测帐号密码');
	  } 
	 
}
}

sub publish{
    my $c = shift;
   $c->entries->add_entries($c->param('title'), $c->param('text'),$c->session->{name});
   
	
}

sub register{
	my $c = shift;
	my $username=$c->param('username');
	my $password=$c->param('password');
	if ($c->users->is_user($username)){
	$c->render(msg => '账号已存在');
	} else {
    my $sql = 'insert into users (name, password) values (?, ?)';
    my $sth = $c->DB->dbh->prepare($sql) or die $c->DB->dbh->errstr;
    $sth->execute($c->param('username'), $c->param('password'))or die $sth->errstr;
	$c->render(msg => '注册成功');
	}
	
}

sub del{
	my $c = shift;
	
}
1;









