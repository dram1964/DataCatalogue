package Catalogue::Controller::IGAdmin;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Catalogue::Controller::IGAdmin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 auto

Deny all access unless user has ig_admin or admin rights

=cut

sub auto : Private {
    my ( $self, $c ) = @_;
    unless ( $c->user->has_role('ig_admin') || $c->user->has_role('admin') ) {
        $c->detach('/error_noperms');
    }
}

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Catalogue::Controller::IGAdmin in IGAdmin.');
}

=head2 base

Can place common logic to start a chained dispatch here

=cut 

sub base : Chained('/') : PathPart('igadmin') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    my $approval_rs =
        $c->model('DB::DataRequest')->search( { status_id => 6 } );
    $c->stash( resultset => $approval_rs );
    $c->load_status_msgs;
}

=head2 object

Fetch the specified data request object based on the class id and store it in the stash

=cut 

sub object : Chained('base') : PathPart('id') : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $c->stash( object => $c->stash->{resultset}->find($id) );

    die "Class not found" if !$c->stash->{object};

}

=head2 list 

List all data requests 

=cut

sub list : Chained('base') : PathPart('list') : Args(0) {
    my ( $self, $c ) = @_;
    my $data_requests = [ $c->stash->{resultset}->all ];
    $c->stash(
        data_requests => $data_requests,
        template      => 'igadmin/list.tt2'
    );
}

=head2 request

Fetch the full request object based on the class id

=cut 

sub request : Chained('base') : PathPart('id') : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $c->stash( object => $c->stash->{resultset}->find($id) );

    die "Class not found" if !$c->stash->{object};
    $c->detach('/error_noperms')
        unless $c->stash->{object}->edit_allowed_by( $c->user->get_object );

    my $data_request = $c->stash->{object};

    my $data_items = [ $data_request->data_request_details ];

    my $dh_rs = $c->model('DB::DataHandling')
        ->search( { request_id => $data_request->id } );
    my $dh = $dh_rs->first;

    my $friendly_identifiers =
        $dh->friendly_identifiers( $c->model('DB::PtIdentifier') );

    my $risks = [ $c->model('DB::RiskCategory')->all ];

    $c->stash(
        dh              => $dh,
        risk_categories => $risks,
        data_items      => $data_items,
        identifiers     => $friendly_identifiers,
        request         => $data_request,
    );
}

=head2 review

review selected data request

=cut

sub review : Chained('request') : PathPart('review') : Args(0) {
    my ( $self, $c ) = @_;

    my $request = $c->stash->{request};
    my $risk_scores_rs =
        $c->model('DB::RiskScore')->search( { request_id => $request->id } );
    my $risk_scores;
    while ( my $row = $risk_scores_rs->next ) {
        my $risk_score = {
            request_id    => $request->id,
            risk_category => $row->risk_category,
            rating        => $row->rating,
            likelihood    => $row->likelihood,
            score         => $row->score
        };
        push @$risk_scores, $risk_score;
    }

    $c->stash(
        risk_scores => $risk_scores,
        template    => 'igadmin/review.tt2'
    );
}

=head2 update_score

submits risk scores to database

=cut 

sub update_score : Chained('object') : PathPart('update_score') : Args(0) {
    my ( $self, $c ) = @_;

    my $request = $c->stash->{object};
    die "Request not found " unless defined($request);
    my $parameters = $c->request->body_parameters;
    for my $suffix ( 1 .. 10 ) {
        next unless defined( $parameters->{ 'category' . $suffix } );
        my $risk_score = {
            request_id    => $request->id,
            risk_category => $parameters->{ 'category' . $suffix },
            rating        => $parameters->{ 'rating' . $suffix },
            likelihood    => $parameters->{ 'likely' . $suffix },
            score         => $parameters->{ 'risk' . $suffix },
        };
        if ( $risk_score->{rating} * $risk_score->{likelihood}
            != $risk_score->{score} )
        {
            $c->log->debug( "*** Risk Score Error on "
                    . $risk_score->{request_id} . ":"
                    . $risk_score->{risk_category}
                    . " ****" );
        }
        my $risk_score_rs =
            $c->model('DB::RiskScore')->update_or_create($risk_score);
    }
    $c->response->redirect(
        $c->uri_for(
            $self->action_for('list'),
            { mid => $c->set_status_msg("Request Scores Submitted") }
        )
    );
    $c->detach;

}

=head2 display

displays selected data request

=cut 

sub display : Chained('request') : PathPart('display') : Args(0) {
    my ( $self, $c ) = @_;

    my $request = $c->stash->{request};
    my $risk_scores_rs =
        $c->model('DB::RiskScore')->search( { request_id => $request->id } );
    my $risk_scores;
    while ( my $row = $risk_scores_rs->next ) {
        my $risk_score = {
            request_id    => $request->id,
            risk_category => $row->risk_category,
            rating        => $row->rating,
            likelihood    => $row->likelihood,
            score         => $row->score
        };
        push @$risk_scores, $risk_score;
    }
    $c->stash(
        risk_scores => $risk_scores,
        template    => 'igadmin/display.tt2'
    );
}

sub complete_review : Chained('object') : PathPart('complete_review') :
    Args(0) {
    my ( $self, $c ) = @_;

    my $request = $c->stash->{object};
    $request->update( { status_id => 8 } );

    $c->response->redirect(
        $c->uri_for(
            $self->action_for('list'),
            {   mid => $c->set_status_msg(
                    $request->id . " flagged for review"
                )
            }
        )
    );
    $c->detach;
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
