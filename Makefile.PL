use inc::Module::Install;
WriteMakefile(
    NAME                => 'Obry',
    AUTHOR              => 'Chris Prather <perigrin@cpan.org>',
    VERSION_FROM        => 'lib/Obry.pm',
    ABSTRACT_FROM       => 'lib/Obry.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Obry-*' },
);
