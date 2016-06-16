package MyApp::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
  my $c = shift;
	 $c->stash(description => 'web framework');
  # Render template "example/welcome.html.ep" with message
  $c->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

sub index {
    my $c = shift;
	   $c->stash(entries=> $c->entries->get_entries);
	   $c->render();
}

sub publish {
  my $c = shift;
  $c->render();
}

sub login {
  my $c = shift;
  $c->render();
}

sub logout{
	my $c=shift;
	$c->session->{name}='';
	$c->render();
}
sub del{
	my $c=shift;
	if ($c->session->{name}){
		if ($c->users->is_author($c->param('id'),$c->session->{name})){
			$c->entries->del_entries($c->param('id'),$c->session->{name});
			$c->render(msg=>'已删除文章');
		} else {
		$c->render(msg=>'这不是你的文章。。。');
		}
	} else {
	$c->render(msg => '未登录');
	}
}
sub user{
    my $c = shift;
	   $c->stash(users => $c->users->get_all_user);
	   $c->render();
}

sub pages {
    my $c = shift;
	   $c->stash(entries=> $c->entries->get_entries_page($c->param('pid')));
	   $c->render();
}

1;
