package Catalogue::Controller::Users;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

Catalogue::Controller::Users - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 auto

Deny all access unless user has admin rights

=cut

sub auto : Private {
    my ( $self, $c ) = @_;
    unless ( $c->user->has_role('admin') ) {
        $c->detach('/error_noperms');
    }
}

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Catalogue::Controller::Users in Users.');
}

=head2 base

Can place common logic to start a chained dispatch here

=cut 

sub base : Chained('/') : PathPart('users') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash( resultset => $c->model('DB::User') );
    $c->load_status_msgs;
}

=head2 object

Fetch the specified user object

=cut 

sub object : Chained('base') : PathPart('id') : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $c->stash( object => $c->stash->{resultset}->find($id) );

    die "Class not found" if !$c->stash->{object};

}

=head2 list 

List all Users 

=cut

sub list : Chained('base') : PathPart('list') : Args(0) {
    my ( $self, $c ) = @_;
    my $users = [ $c->stash->{resultset}->all ];
    $c->stash(
        users    => $users,
        template => 'users/list.tt2'
    );
}

=head2 add

Add new User - check if username in use already

=cut

sub add : Chained('base') : PathPart('add') : Args(0) : FormConfig {
    my ( $self, $c ) = @_;

    my $form = $c->stash->{form};
    if ( $form->submitted_and_valid ) {
        if (defined $c->stash->{resultset}
            ->single( { username => $c->request->params->{username} } ) )
        {
            $c->response->redirect(
                $c->uri_for(
                    $self->action_for('list'),
                    {   mid => $c->set_error_msg(
                                  "Username "
                                . $c->request->params->{username}
                                . " already in use"
                        )
                    }
                )
            );
            $c->detach;
        }

        my $user = $c->model('DB::User')->new_result(
            {   username      => $c->request->params->{username},
                email_address => $c->request->params->{email_address},
                first_name    => $c->request->params->{first_name},
                last_name     => $c->request->params->{last_name},
                password      => $c->request->params->{password},
                active        => $c->request->params->{active},
            }
        );
        $form->model->update($user);
        my @roles = $c->request->params->{roles};
        for my $id (@roles) {
            my $user_roles = $c->model('DB::UserRole')->find_or_create(
                {   user_id => $user->id,
                    role_id => $id
                }
            );
        }
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_status_msg("User Added") }
            )
        );
        $c->detach;
    }
    my @role_objs = $c->model('DB::Role')->search( {}, { sort => 'id' } );
    my @roles;
    foreach (@role_objs) {
        push( @roles, [ $_->id, $_->role ] );
    }
    my $roles_select = $form->get_element( { name => 'roles' } );
    $roles_select->options( \@roles );

    $c->stash( template => 'users/add.tt2' );
}

=head2 edit

Edit a user record

=cut

sub edit : Chained('object') : PathPart('edit') : Args(0)
    : FormConfig('users/edit.yml') {
    my ( $self, $c ) = @_;

    my $user = $c->stash->{object};
    unless ($user) {
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_error_msg("Invalid user -- Cannot edit") }
            )
        );
        $c->detach;
    }
    my $form = $c->stash->{form};
    if ( $form->submitted_and_valid ) {
        $form->model->update($user);
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_status_msg("User updated") }
            )
        );
        $c->detach;
    }
    else {
        my $username = $form->get_element( { name => 'username' } );
        $username->value( $user->username );
        my $last_name = $form->get_element( { name => 'last_name' } );
        $last_name->value( $user->last_name ) if $user->last_name;
        my $first_name = $form->get_element( { name => 'first_name' } );
        $first_name->value( $user->first_name ) if $user->first_name;
        my $email = $form->get_element( { name => 'email_address' } );
        $email->value( $user->email_address ) if $user->email_address;
        $c->stash( user => $user );
        my $active = $form->get_element( { name => 'active' } );
        $active->value( $user->active );

        my @role_objs = $c->model('DB::Role')->search( {}, { sort => 'id' } );
        my @roles;
        foreach (@role_objs) {
            push( @roles, [ $_->id, $_->role ] );
        }
        my @user_roles = $user->roles;
        my @current_roles;
        foreach (@user_roles) {
            push @current_roles, $_->id;
        }
        my $roles_select = $form->get_element( { name => 'roles' } );
        $roles_select->options( \@roles );
        $roles_select->value( \@current_roles );
    }
    $c->stash( template => 'users/add.tt2' );
}

=head2 search

Search for Users

=cut

sub search : Chained('base') : PathPart('search') : Args(0) {
    my ( $self, $c ) = @_;
    my $search_term = "%" . $c->request->params->{search} . "%";
    my $user_rs     = $c->stash->{resultset}->search(
        {   -or => [
                { 'username'      => { like => $search_term } },
                { 'first_name'    => { like => $search_term } },
                { 'last_name'     => { like => $search_term } },
                { 'email_address' => { like => $search_term } },
            ]
        }
    );
    my $users = [ $user_rs->all ];
    $c->stash(
        users    => $users,
        template => 'users/list.tt2'
    );
}

=head2 delete

Delete a user from the todolist

=cut 

sub delete : Chained('object') : PathPart('delete') : Args(0) {
    my ( $self, $c ) = @_;

    if ( $c->stash->{object}->id == $c->user->id ) {
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_error_msg("Can't delete own account") }
            )
        );
        $c->detach;
    }
    $c->stash->{object}->delete;
    $c->response->redirect(
        $c->uri_for(
            $self->action_for('list'),
            { mid => $c->set_status_msg("User Deleted") }
        )
    );
}

=encoding utf8

=head1 AUTHOR

dr00

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
