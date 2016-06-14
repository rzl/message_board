package MyApp::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
  my $self = shift;
	 $self->stash(description => 'web framework');
  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

sub index {
    my $self = shift;
	my $dbh=$self->AppDB->getcon;
	my @res=$dbh->resultset('PlArticle')->all;
	   $self->stash(entries=> [@res]);
	   $self->render();
	   $self->AppDB->putcon($dbh);
}

sub publish {
  my $self = shift;
  $self->render();
}

sub login {
  my $self = shift;

  $self->render();
}

sub logout{
	my $self=shift;
	$self->session->{name}='';
	$self->render();
}
sub del{
	my $self=shift;
	if ($self->session->{name}){
		if ($self->users->isauthor($self->param('id'),$self->session->{name})){
			$self->users->delaricle($self->param('id'),$self->session->{name});
			$self->render(msg=>'已删除文章');
		} else {
		$self->render(msg=>'这不是你的文章。。。');
		}
	} else {
	$self->render(msg => '未登录');
	}
}

1;
