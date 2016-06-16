package MyApp::Model::DB;
use Mojo::Base -base;
use DBI;

has db_name => '';
has dbh => '';

sub  connect_db {
	my $dbh = DBI->connect("dbi:SQLite:dbname=".$_[0]->db_name) or die $DBI::errstr;
	$dbh->{sqlite_unicode} = 1;
	$_[0]->dbh($dbh);
	#unicode输出，不然会出现中文乱码	 
}

sub create_dbfile{
	my ($s, $db_name) = @_;
	my $dbfile= File::Spec->catfile(File::Spec->curdir(), $db_name.'.db');
	$s->db_name($dbfile);
	my $dbh = DBI->connect("dbi:SQLite:dbname=".$dbfile) or die $DBI::errstr;
	$dbh->{sqlite_unicode} = 1;
	$s->dbh($dbh);
	my $table1 = '
  create table if not exists entries (
  id integer primary key autoincrement,
  title string not null,
  text string not null,
  author string not null,
  logtime TIMESTAMP default CURRENT_TIMESTAMP
);
';
	my $table2= '
  create table if not exists users  (
  id integer primary key autoincrement,
  name string not null,
  password string not null,
  tid integer DEFAULT 0 
);
';
$dbh->do($table1) or die $dbh->errstr;
$dbh->do($table2) or die $dbh->errstr;
}


1;