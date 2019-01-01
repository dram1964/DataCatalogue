package Catalogue::Controller::ExtractApproval;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Catalogue::Controller::ExtractApproval - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 auto

Deny all access unless user has extract_approver or admin rights

=cut

sub auto : Private {
    my ( $self, $c ) = @_;
    unless ( $c->user->has_role('extract_approver')
        || $c->user->has_role('admin') )
    {
        $c->detach('/error_noperms');
    }
}

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body(
        'Matched Catalogue::Controller::ExtractApproval in ExtractApproval.');
}

=head2 base

Adds a resultset for DataRequest to the stash for chained dispatch. Also 
uses flash load_status_msg to handle status messages

=cut 

sub base : Chained('/') : PathPart('extract_approval') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash( resultset => $c->model('DB::DataRequest') );
    $c->load_status_msgs;
}

=head1 list

Display list of requests that have had IG Review complsted

=cut

sub list : Chained('base') : PathPart('list') : Args(0) {
    my ( $self, $c ) = @_;
    my $data_requests =
        [ $c->stash->{resultset}->search( { status_id => { in => [8] } } ) ];
    $c->stash(
        data_requests => $data_requests,
        template      => 'extract_approval/list.tt2'
    );
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
        template    => 'extract_approval/display_request.tt2'
    );
}

=head2 update_approval

updates request status with submitted request_status

=cut 

sub update_approval : Chained('object') : Args() {
    my ( $self, $c ) = @_;
    my $data_request  = $c->stash->{object};
    my $data_requests = $c->stash->{data_requests};
    my $parameters    = $c->request->body_parameters;
    if ( $data_request->update( { status_id => $parameters->{approval} } ) ) {
        $c->stash(
            status_msg    => "Request " . $data_request->id . " updated",
            data_requests => $data_requests,
            template      => 'extract_approval/list.tt2'
        );
    }
    else {
        $c->stash(
            error_msg     => "Error Updating Request " . $data_request->id,
            data_requests => $data_requests,
            template      => 'extract_approval/list.tt2'
        );
    }
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
