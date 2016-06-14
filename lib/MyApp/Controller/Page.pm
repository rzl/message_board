package MyApp::Controller::Page;
use Mojo::Base 'Mojolicious::Controller';

sub pages {
    my $self = shift;
	my $dbh = $self->AppDB->getcon();
    my $sql = 'select * from entries where id >'. ($self->param('pid')-1)*5 .' LIMIT 5';
    my $sth = $dbh->prepare($sql) or die $dbh->errstr;
       $sth->execute or die $sth->errstr;
	   $self->stash(entries=> $sth-> fetchall_arrayref);
	   $self->render();
	   $self->AppDB->putcon($dbh);
}
1;