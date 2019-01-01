package Catalogue::Controller::Registration;
use Moose;
use Date::Format;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Catalogue::Controller::Registration - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body(
        'Matched Catalogue::Controller::Registration in Registration.');
}

=head2 base

Can place common logic to start a chained dispatch here

=cut 

sub base : Chained('/') : PathPart('registration') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash( resultset => $c->model('DB::RegistrationRequest') );

    $c->detach('/error_noperms')
        unless $c->stash->{resultset}
        ->first->edit_allowed_by( $c->user->get_object );

    $c->load_status_msgs;
}

=head2 object

Fetch the specified registration request object based on the class id and store it in the stash

=cut 

sub object : Chained('base') : PathPart('id') : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $c->stash( object => $c->stash->{resultset}->find($id) );

    die "Class not found" if !$c->stash->{object};

}

=head2 list 

List all registration requests 

=cut

sub list : Chained('base') : PathPart('list') : Args(0) {
    my ( $self, $c ) = @_;

    my $requests = [
        $c->stash->{resultset}->search(
            { approved_by => { '=', undef } },
            { order_by => { -asc => 'approval_date' } }
        )
    ];
    $c->stash(
        requests => $requests,
        template => 'registration/list.tt2'
    );
}

=head2 review

review selected registration request

=cut

sub review : Chained('object') : PathPart('review') : Args(0) {
    my ( $self, $c ) = @_;

    my $request = $c->stash->{object};
    unless ($request) {
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                {   mid => $c->set_error_msg("Invalid Request -- Cannot edit")
                }
            )
        );
        $c->detach;
    }

    $c->stash(
        request  => $request,
        template => 'registration/review.tt2'
    );
}

=head2 create_user_from_request

use the provided details to create the user account

=cut

sub create_user_from_request : Chained('object') :
    PathPart('create_user_from_request') : Args(0) {
    my ( $self, $c ) = @_;

    my $registration = $c->stash->{object};
    #my $roles        = $c->request->params->{roles};
    my @roles;
    push @roles, $c->request->params->{role_user};
    push @roles, $c->request->params->{role_admin};
    push @roles, $c->request->params->{role_verifier};
    push @roles, $c->request->params->{role_requestor};
    push @roles, $c->request->params->{role_igadmin};
    push @roles, $c->request->params->{role_extractor};
    push @roles, $c->request->params->{role_extract_approver};
    unless ($registration) {
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                {   mid => $c->set_error_msg("Invalid Request -- Cannot edit")
                }
            )
        );
        $c->detach;
    }
    my $update_time = time2str( "%Y-%m-%d %H-%M-%S", time );
    my $user_check = $c->model('DB::User')->search(
        {   -or => [
                id            => $registration->email_address,
                username      => $registration->email_address,
                email_address => $registration->email_address,
            ]
        }
    );
    my $status_msg;
    if ( $user_check->next ) {
        $c->stash( error_msg => $registration->email_address
                . 'already in use as a username or email address' );
        $c->log->debug( "*** " . $c->stash->{error_msg} . " ***" );
    }
    else {
        my $user = $c->model('DB::User')->create(
            {   username      => $registration->email_address,
                email_address => $registration->email_address,
                first_name    => $registration->first_name,
                last_name     => $registration->last_name,
                password      => $registration->password,
                job_title     => $registration->job_title,
                department    => $registration->department,
                organisation  => $registration->organisation,
                address1      => $registration->address1,
                address2      => $registration->address2,
                address3      => $registration->address3,
                postcode      => $registration->postcode,
                city          => $registration->city,
                telephone     => $registration->telephone,
                mobile        => $registration->mobile,
                active        => 1,
            }
        );
        for my $role (@roles) {
            next unless defined $role;
            my $user_role = $c->model('DB::UserRole')->create(
                {   user_id => $user->id,
                    role_id => $role,
                }
            );
        }
        $registration->approval_date($update_time);
        $registration->approved_by( $c->user->username );
        $registration->user_id( $user->id );
        $registration->update;
        $status_msg = "User created!" if defined($user);
    }

    $c->stash(
        status_msg => $status_msg,
        requests   => $registration,
        template   => 'registration/list.tt2'
    );
}

=head2 ng_new

displays page for new users to register their details on angularised form

=cut

sub ng_new : Path('new') : Args(0) {
    my ( $self, $c ) = @_;

    if ( $c->user_exists ) {
        $c->detach('/logged_in');
    }

    $c->stash( template => 'registration/new.tt2' );
}

=head2 ng_new_submitted

adds new registration request to the database

=cut

sub ng_new_submitted : Path('ng_new_submitted') : Args(0) {
    my ( $self, $c, $user ) = @_;
    my $reg;
    my $details = {
        last_name     => $c->request->params->{lastName},
        first_name    => $c->request->params->{firstName},
        email_address => $c->request->params->{email1},
        password      => $c->request->params->{password1},
        job_title     => $c->request->params->{jobTitle},
        department    => $c->request->params->{department},
        organisation  => $c->request->params->{organisation},
        address1      => $c->request->params->{address1},
        address2      => $c->request->params->{address2},
        address3      => $c->request->params->{address3},
        postcode      => $c->request->params->{postcode},
        city          => $c->request->params->{city},
        telephone     => $c->request->params->{telephone},
        mobile        => $c->request->params->{mobile},
        agree1        => $c->request->params->{agree1},
        agree2        => $c->request->params->{agree2},
        agree3        => $c->request->params->{agree3},
    };
    my $user_check = $c->model('DB::RegistrationRequest')
        ->find( $details->{email_address} );
    if ( defined $user_check ) {
        $c->stash(error_msg => 'User '
                . $details->{email_address}
                . ' already in use' );
        $c->log->debug( "*** " . $c->stash->{error_msg} . " ***" );
    }
    else {
        $reg = $c->model('DB::RegistrationRequest')->create($details);
    }

    $c->stash(
        reg      => $reg,
        template => 'registration/new_submitted.tt2'
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
