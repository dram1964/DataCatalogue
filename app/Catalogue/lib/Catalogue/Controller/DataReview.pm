package Catalogue::Controller::DataReview;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Catalogue::Controller::DataReview - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 auto

Deny all access unless user has verifier or admin rights

=cut

sub auto : Private {
    my ( $self, $c ) = @_;
    unless ( $c->user->has_role('verifier') || $c->user->has_role('admin') ) {
        $c->detach('/error_noperms');
    }
}

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body(
        'Matched Catalogue::Controller::DataReview in DataReview.');
}

=head2 base

Can place common logic to start a chained dispatch here

=cut 

sub base : Chained('/') : PathPart('datareview') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash( resultset => $c->model('DB::DataRequest') );
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
    unless ($data_request) {
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                {   mid => $c->set_error_msg("Invalid Request -- Cannot edit")
                }
            )
        );
        $c->detach;
    }
    my $data_items = [ $data_request->data_request_details ];

    my $dh_rs = $c->model('DB::DataHandling')
        ->search( { request_id => $data_request->id } );
    my $dh = $dh_rs->first;

    my $friendly_identifiers =
        $dh->friendly_identifiers( $c->model('DB::PtIdentifier') );

    my $verify_purpose = $c->model('DB::VerifyPurpose')
        ->find( { request_id => $data_request->id } );
    if ( defined($verify_purpose) ) {
        $c->stash->{verify}->{area_comment} = $verify_purpose->area_comment;
        $c->stash->{verify}->{objective_comment} =
            $verify_purpose->objective_comment;
        $c->stash->{verify}->{benefits_comment} =
            $verify_purpose->benefits_comment;
        $c->stash->{verify}->{responsible_comment} =
            $verify_purpose->responsible_comment;
        $c->stash->{verify}->{organisation_comment} =
            $verify_purpose->organisation_comment;
    }
    my $verify_handling = $c->model('DB::VerifyHandling')
        ->find( { request_id => $data_request->id } );
    if ( defined($verify_handling) ) {
        $c->stash->{verify}->{id_comment}  = $verify_handling->id_comment;
        $c->stash->{verify}->{rec_comment} = $verify_handling->rec_comment;
        $c->stash->{verify}->{population_comment} =
            $verify_handling->population_comment;
        $c->stash->{verify}->{publish_comment} =
            $verify_handling->publish_comment;
    }

    my $verify_manage = $c->model('DB::VerifyManage')
        ->find( { request_id => $data_request->id } );
    if ( defined($verify_manage) ) {
        $c->stash->{verify}->{storing_comment} =
            $verify_manage->storing_comment;
        $c->stash->{verify}->{secure_comment} =
            $verify_manage->secure_comment;
        $c->stash->{verify}->{completion_comment} =
            $verify_manage->completion_comment;
    }

    my $verify_data = $c->model('DB::VerifyData')
        ->find( { request_id => $data_request->id } );
    if ( defined($verify_data) ) {
        $c->stash->{verify}->{cardiology_comment} =
            $verify_data->cardiology_comment;
        $c->stash->{verify}->{diagnosis_comment} =
            $verify_data->diagnosis_comment;
        $c->stash->{verify}->{episode_comment} =
            $verify_data->episode_comment;
        $c->stash->{verify}->{other_comment} = $verify_data->other_comment;
        $c->stash->{verify}->{pathology_comment} =
            $verify_data->pathology_comment;
        $c->stash->{verify}->{pharmacy_comment} =
            $verify_data->pharmacy_comment;
        $c->stash->{verify}->{radiology_comment} =
            $verify_data->radiology_comment;
        $c->stash->{verify}->{theatre_comment} =
            $verify_data->theatre_comment;
    }

    $c->stash(
        dh          => $dh,
        data_items  => $data_items,
        request     => $data_request,
        identifiers => $friendly_identifiers,
        template    => 'datareview/review.tt2'
    );
}

=head2 review

review selected data request

=cut

sub review : Chained('request') : PathPart('review') : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( template => 'datareview/review.tt2' );
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
        template    => 'datareview/display.tt2'
    );
}

=head2 request_ig_review

flags request as ready for IG review then displays request in PDF format

=cut

sub request_ig_review : Chained('request') : PathPart('request_ig_review') :
    Args(0) {
    my ( $self, $c ) = @_;

    my $request = $c->stash->{request};
    $request->update( { status_id => 6 } );

    $c->response->redirect(
        $c->uri_for(
            $self->action_for('list'),
            {   mid => $c->set_status_msg(
                    $request->id . " flagged for IG review"
                )
            }
        )
    );
    $c->detach;
}

sub enable_review : Chained('object') : PathPart('enable_review') : Args(0) {
    my ( $self, $c ) = @_;

    my $request = $c->stash->{object};
    $request->update( { status_id => 3 } );

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

=head2 list 

List all data requests 

=cut

sub list : Chained('base') : PathPart('list') : Args(0) {
    my ( $self, $c ) = @_;
    my $data_requests = [ $c->stash->{resultset}->all ];
    $c->stash(
        data_requests => $data_requests,
        template      => 'datareview/list.tt2'
    );
}

=head2 purpose_verify

verify or add comments to request purpose and request purpose history

=cut 

sub purpose_verify : Chained('object') : PathPart('purpose_verify') : Args(0)
{
    my ( $self, $c ) = @_;
    my $data_request = $c->stash->{object};
    my $parameters   = $c->request->body_parameters;

    my $verifier = $c->user->get_object;

    my $dh_rs = $c->model('DB::DataHandling')
        ->search( { request_id => $data_request->id } );
    my $dh = $dh_rs->first;

    my $purpose_verify = {
        request_id           => $data_request->id,
        verifier             => $verifier->id,
        verification_time    => undef,
        area                 => $dh->area,
        area_comment         => $parameters->{area_comment} || undef,
        objective            => $dh->objective,
        objective_comment    => $parameters->{objective_comment} || undef,
        benefits             => $dh->benefits,
        benefits_comment     => $parameters->{benefits_comment} || undef,
        responsible          => $dh->responsible,
        responsible_comment  => $parameters->{responsible_comment} || undef,
        organisation         => $dh->benefits,
        organisation_comment => $parameters->{organisation_comment} || undef,
    };

    my $verification =
        $c->model('DB::VerifyPurpose')->update_or_create( $purpose_verify );
    my $verification_history =
        $c->model('DB::VerifyPurposeHistory')->create( $purpose_verify );
    $data_request->update( { status_id => 4 } );
    my $request_history = $c->model('DB::RequestHistory')->create(
        {   request_id      => $data_request->id,
            user_id         => $verifier->id,
            request_type_id => $data_request->request_type_id,
            status_id       => $data_request->status_id,
            status_date     => undef,
        }
    );
    $c->response->redirect(
        $c->uri_for( $self->action_for('review'), [ $data_request->id ] ) );
    $c->detach;
}

=head2 handling_verify

verify handling for submitted request

Need to add the handling values to the data_handling and data_handling_history tables

=cut 

sub handling_verify : Chained('object') : PathPart('handling_verify') :
    Args(0) {
    my ( $self, $c ) = @_;
    my $data_request = $c->stash->{object};
    my $parameters   = $c->request->body_parameters;

    my $verifier        = $c->user->get_object;
    my $handling_verify = {
        request_id         => $data_request->id,
        verifier           => $verifier->id,
        verification_time  => undef,
        id_comment         => $parameters->{id_comment},
        rec_comment        => $parameters->{rec_comment},
        population_comment => $parameters->{population_comment},
        publish_comment    => $parameters->{publish_comment},

    };

    my $verification =
        $c->model('DB::VerifyHandling')->update_or_create( $handling_verify );
    my $verification_history =
        $c->model('DB::VerifyHandlingHistory')->create( $handling_verify );
    $data_request->update( { status_id => 4 } );
    my $request_history = $c->model('DB::RequestHistory')->create(
        {   request_id      => $data_request->id,
            user_id         => $verifier->id,
            request_type_id => $data_request->request_type_id,
            status_id       => $data_request->status_id,
            status_date     => undef,
        }
    );
    $c->response->redirect(
        $c->uri_for( $self->action_for('review'), [ $data_request->id ] ) );
    $c->detach;

}

=head2 manage_verify

verify data management for submitted request

=cut 

sub manage_verify : Chained('object') : PathPart('manage_verify') : Args(0) {
    my ( $self, $c ) = @_;
    my $data_request = $c->stash->{object};
    my $parameters   = $c->request->body_parameters;

    my $verifier      = $c->user->get_object;
    my $manage_verify = {
        request_id         => $data_request->id,
        verifier           => $verifier->id,
        verification_time  => undef,
        storing_comment    => $parameters->{storing_comment},
        secure_comment     => $parameters->{secure_comment},
        completion_comment => $parameters->{completion_comment},

    };

    my $verification =
        $c->model('DB::VerifyManage')->update_or_create( $manage_verify );
    my $verification_history =
        $c->model('DB::VerifyManageHistory')->create( $manage_verify );
    $data_request->update( { status_id => 4 } );
    my $request_history = $c->model('DB::RequestHistory')->create(
        {   request_id      => $data_request->id,
            user_id         => $verifier->id,
            request_type_id => $data_request->request_type_id,
            status_id       => $data_request->status_id,
            status_date     => undef,
        }
    );
    $c->response->redirect(
        $c->uri_for( $self->action_for('review'), [ $data_request->id ] ) );
    $c->detach;

}

=head2 data_verify

verify data for submitted request

=cut 

sub data_verify : Chained('object') : PathPart('data_verify') : Args(0) {
    my ( $self, $c ) = @_;
    my $data_request = $c->stash->{object};
    my $parameters   = $c->request->body_parameters;
    my $verifier     = $c->user->get_object;
    my $data_verify  = {
        request_id        => $data_request->id,
        verifier          => $verifier->id,
        verification_time => undef,

    };
    my $data_category_rs = $c->model('DB::DataCategory');
    while ( my $category = $data_category_rs->next ) {
        if ( $parameters->{ $category->category . '_comment' } ) {
            $data_verify->{ $category->category . '_comment' } =
                $parameters->{ $category->category . '_comment' };
        }
    }

    my $verification =
        $c->model('DB::VerifyData')->update_or_create( $data_verify );
    my $verification_history =
        $c->model('DB::VerifyDataHistory')->create( $data_verify );
    $data_request->update( { status_id => 4 } );
    my $request_history = $c->model('DB::RequestHistory')->create(
        {   request_id      => $data_request->id,
            user_id         => $verifier->id,
            request_type_id => $data_request->request_type_id,
            status_id       => $data_request->status_id,
            status_date     => undef,
        }
    );

    $c->response->redirect(
        $c->uri_for( $self->action_for('review'), [ $data_request->id ] ) );
    $c->detach;

}

=head2 request_user_review

flag request for review by user

=cut

sub request_user_review : Chained('object') : PathPart('request_user_review')
    : Args(0) {
    my ( $self, $c ) = @_;
    my $request = $c->stash->{object};
    $request->update( { status_id => 5 } );
    $c->response->redirect(
        $c->uri_for(
            $self->action_for('list'),
            {   mid => $c->set_status_msg(
                    "Request " . $request->id . " Submitted for user review"
                )
            }
        )
    );
    $c->detach;
}

=encoding utf8

=head1 AUTHOR

David Ramlakhan,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
