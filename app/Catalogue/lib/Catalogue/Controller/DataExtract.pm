package Catalogue::Controller::DataExtract;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Catalogue::Controller::DataExtract - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

=head2 auto

Deny all access unless user has extractor or admin rights

=cut

sub auto : Private {
    my ( $self, $c ) = @_;
    unless ( $c->user->has_role('extractor') || $c->user->has_role('admin') )
    {
        $c->detach('/error_noperms');
    }
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body(
        'Matched Catalogue::Controller::DataExtract in DataExtract.');
}

=head2 base

Adds a resultset for DataRequest to the stash for chained dispatch. Also 
uses flash load_status_msg to handle status messages

=cut 

sub base : Chained('/') : PathPart('dataextract') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash( resultset => $c->model('DB::DataRequest') );
    $c->load_status_msgs;
}

=head2 object

Fetch the specified data request object based on the request id and store it in the stash. 

=cut 

sub object : Chained('base') : PathPart('id') : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    $c->stash( object => $c->stash->{resultset}->find($id) );
    die "Class not found" if !$c->stash->{object};
}

=head2 display_request

Displays the data requested

=cut

sub display_request : Chained('object') : Args() {
    my ( $self, $c ) = @_;
    my $data_request = $c->stash->{object};

    die "Class not found" if !$c->stash->{object};
    $c->detach('/error_noperms')
        unless $data_request->extract_allowed_by( $c->user->get_object );

    my $dh_rs = $c->model('DB::DataHandling')
        ->search( { request_id => $data_request->id } );
    my $risk_scores_rs = $c->model('DB::RiskScore')
        ->search( { request_id => $data_request->id } );
    my $risk_scores;
    while ( my $row = $risk_scores_rs->next ) {
        my $risk_score = {
            request_id    => $data_request->id,
            risk_category => $row->risk_category,
            rating        => $row->rating,
            likelihood    => $row->likelihood,
            score         => $row->score
        };
        push @$risk_scores, $risk_score;
    }

    my $dh = $dh_rs->first;

    my $friendly_identifiers =
        $dh->friendly_identifiers( $c->model('DB::PtIdentifier') );

    $c->stash(
        dh          => $dh,
        risk_scores => $risk_scores,
        request     => $data_request,
        identifiers => $friendly_identifiers,
        template    => 'dataextract/display_request.tt2'
    );
}

=head2 display_submissions

Displays data submitted for a specified request

=cut 

sub display_submissions : Chained('object') : Args(0) {
    my ( $self, $c ) = @_;
    my $data_request = $c->stash->{object};
    my $submissions  = [ $data_request->submissions ];

    $c->stash(
        request     => $data_request,
        submissions => $submissions,
        template    => 'dataextract/display_submissions.tt2',
    );
}

=head2 add_new 

Adds a new submission record for selected request

=cut

sub add_new : Chained('object') : Args(0) {
    my ( $self, $c ) = @_;
    my $data_request = $c->stash->{object};
    $c->stash(
        request  => $data_request,
        template => 'dataextract/add.tt2',
    );
}

=head2 add_submission

Sends the form data for new submission to the database

=cut 

sub add_submission : Chained('object') : Args(0) {
    my ( $self, $c ) = @_;
    my $data_request    = $c->stash->{object};
    my $parameters      = $c->request->body_parameters;
    my $submission_data = {
        request_id          => $data_request->id,
        project_name        => $parameters->{projectName},
        project_type        => $parameters->{projectType},
        project_location    => $parameters->{projectLocation},
        extract_run_date    => $parameters->{extractRunDate},
        extract_output_file => $parameters->{extractOutputFile},
        extract_output_file_location =>
            $parameters->{extractOutputFileLocation},
        extract_delivery_method => $parameters->{extractDeliveryMethod},
    };
    my $submission = $c->model('DB::Submission')->create($submission_data);

    $c->stash( template => 'dataextract/list.tt2', );
}

=head2 edit

Displays template for editing or adding details of data extract

=cut

sub edit : Chained('object') : Args(0) {
    my ( $self, $c ) = @_;
    my $data_request = $c->stash->{object};
    my $submissions  = [ $c->model('DB::Submission')
            ->search( { request_id => $data_request->id } ) ];
    $c->stash(
        submissions => $submissions,
        request     => $data_request,
        template    => 'dataextract/edit.tt2',
    );
}

=head2 flag_complete

Flags the request as completed with data delivered

=cut

sub flag_complete : Chained('object') : Args(0) {
    my ( $self, $c ) = @_;
    my $data_request  = $c->stash->{object};
    my $data_requests = $c->stash->{data_requests};
    if ( $data_request->update( { status_id => 11 } ) ) {
        $c->stash(
            status_msg    => "Request " . $data_request->id . " updated",
            data_requests => $data_requests,
            template      => 'dataextract/list.tt2'
        );
    }
    else {
        $c->stash(
            error_msg     => "Error Updating Request " . $data_request->id,
            data_requests => $data_requests,
            template      => 'dataextract/list.tt2'
        );
    }
}

=head1 list

Display list of requests that have had IG Review complsted
or data submission data recorded

=cut

sub list : Chained('base') : PathPart('list') : Args(0) {
    my ( $self, $c ) = @_;
    my $data_requests = [
        $c->stash->{resultset}->search( { status_id => { in => [ 9, 12 ] } } )
    ];
    $c->stash(
        data_requests => $data_requests,
        template      => 'dataextract/list.tt2'
    );
}

=encoding utf8

=head1 AUTHOR

Ubuntu

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
