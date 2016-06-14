package MyApp::Controller::Install;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

sub setpone{
  my $c = shift;
  my $msg;
   -w 'conf/db.conf' ? $msg='can not write': $msg='can write';
  $c->stash(msg => $msg);
  # Render template "example/welcome.html.ep" with message
  if (defined($c->param('install'))){
  $c->render(text=>$msg);
  
  my $mt = Mojo::Template->new;
my $output = $mt->render(<<'EOF');
% use Time::Piece;
<!DOCTYPE html>
<html>
  <head><title>Simple</title></head>
  % my $now = localtime;
  <body>Time: <%= $now->hms %></body>
</html>
EOF
  say "start install db";
  say "creat 2";
  for (1..5){
  $c->render(text =>$output);
  sleep(int(rand(2)));
  }
	
  $c->finish;
  }
  $c->render;
 
  

}

sub setptwo{
	my $c=shift;
	$c->render();
}

1;