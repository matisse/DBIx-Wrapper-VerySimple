use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'DBI::Wrapper',
    'VERSION_FROM'	=> 'Wrapper.pm', # finds $VERSION
    'PREREQ_PM'		=> { DBI => 1.34, }, # e.g., Module::Name => 1.1
    'ABSTRACT'          => 'Wrapper around DBI providing very simple interface.',
    'AUTHOR'            => 'Matisse Enzer <matisse@matisse.net>',
);
