package Catalogue::Controller::DataRequest;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Catalogue::Controller::DataRequest - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 auto

Deny all access unless user has requestor or admin rights

=cut

sub auto : Private {
    my ( $self, $c ) = @_;
    unless ( $c->user->has_role('requestor') || $c->user->has_role('admin') )
    {
        $c->stash( error_msg =>
                'Your account does not have permission to make data requests. '
                . 'Please contact your administrator' );
        $c->detach('/error_noperms');
    }
}

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body(
        'Matched Catalogue::Controller::DataRequest in DataRequest.');
}

=head2 base

Adds a resultset for DataRequest and a user object to the stash for chained dispatch. Also 
uses flash load_status_msg to handle status messages

=cut 

sub base : Chained('/') : PathPart('datarequest') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash( resultset => $c->model('DB::DataRequest') );
    $c->stash( user      => $c->user->get_object );
    $c->load_status_msgs;
}

=head2 object

Fetch the specified data request object based on the class id and store it in the stash. Checks
that the requests user_id matches the current users id

=cut 

sub object : Chained('base') : PathPart('id') : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $c->stash( object => $c->stash->{resultset}->find($id) );
    die "Class not found" if !$c->stash->{object};

    $c->detach('/error_noperms')
        unless $c->stash->{object}->user_id eq $c->stash->{user}->id;

}

=head2 list 

List all data requests for current user 

=cut

sub list : Chained('base') : PathPart('list') : Args(0) {
    my ( $self, $c ) = @_;
    my $data_requests = [
        $c->stash->{resultset}->search( { user_id => $c->stash->{user}->id } )
    ];
    $c->stash(
        data_requests => $data_requests,
        template      => 'datarequest/list.tt2'
    );
}

=head2 display

display selected data request

=cut

sub display : Chained('object') : PathPart('display') : Args(0) {
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
        template    => 'datarequest/display.tt2'
    );
}

=head2 new_request

Displays a form for requesting data

=cut

sub new_request : Chained('base') : PathPart('new_request') : Args(0) {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless $c->stash->{resultset}->new( {} )
        ->request_allowed_by( $c->stash->{user} );
    my $requestor =
        $c->model('DB::User')->find( { id => $c->stash->{user}->id, } );

    my $request_types  = [ $c->model('DB::RequestType')->all ];
    my $data_categorys = [ $c->model('DB::DataCategory')->all ];
    my $legal_basis    = [ $c->model('DB::LegalBasis')->all ];
    my $pt_identifiers = [ $c->model('DB::PtIdentifier')->all ];
    $c->stash(
        requestor      => $requestor,
        request_types  => $request_types,
        data_categorys => $data_categorys,
        legal_basis    => $legal_basis,
        pt_identifiers => $pt_identifiers,
        template       => 'datarequest/request.tt2'
    );
}

=head2 _identifiers

Method to retrieve unique elements of identifiers array parameter to string value

=cut

sub _identifiers () {
    my $self = shift;

    if ( ref $self->{identifiers} eq "ARRAY" ) {
        my %hash = map { $_, 1 } @{ $self->{identifiers} };
        $self->{identifiers} = join( ", ", keys(%hash) );
    }
    return $self->{identifiers};
}

=head2 validate_date

Used to format submitted text field to acceptable date format

=cut

sub validate_date() {
    my $self            = shift;
    my $completion_date = shift;
    $completion_date
        =~ /(?<year>[0-2]\d{3,3})-(?<month>[0-1]\d{1,1})-(?<day>[0-3][0-9])/;
    return undef unless $+{year} > 2016;
    return undef unless $+{month} < 13 && $+{month} > 0;
    return undef unless $+{day} < 32 && $+{day} > 0;
    return $completion_date;
}

=head2 ng_request_submitted

Submits data request to database

=cut

sub ng_request_submitted : Chained('base') PathPart('ng_request_submitted') :
    Args() {
    my ( $self, $c ) = @_;

    my $parameters = $c->request->body_parameters;
    my $dr         = {
        user_id         => $c->stash->{user}->id,
        request_type_id => $parameters->{requestType},
        status_id       => $parameters->{Submit},
    };
    my $data_request = $c->model('DB::DataRequest')->create($dr);

    my $data_categorys_rs = $c->model('DB::DataCategory');

    while ( my $row = $data_categorys_rs->next ) {
        if ( defined( $parameters->{ $row->category } )
            && $parameters->{ $row->category } eq 'on' )
        {
            $c->model('DB::DataRequestDetail')->create(
                {   data_request_id  => $data_request->id,
                    data_category_id => $row->id,
                    detail => $parameters->{ $row->category . "Details" },
                }
            );
            $c->model('DB::RequestDetailHistory')->create(
                {   data_request_id  => $data_request->id,
                    data_category_id => $row->id,
                    detail => $parameters->{ $row->category . "Details" },
                    status_date => $data_request->status_date,
                }
            );
        }
    }

    my $request_type = $data_request->request_type_id;
    $self->{identifiers} = $parameters->{ "identifiers" . $request_type };
    my $completion_date =
        $self->validate_date( $parameters->{completion_date} );
    my $dh = {
        request_id     => $data_request->id,
        identifiers    => $self->_identifiers,
        area           => $parameters->{ "area" . $request_type },
        identifiable   => $parameters->{ "identifiable" . $request_type },
        pid_justify    => $parameters->{ "pidJustify" . $request_type },
        legal_basis_id => $parameters->{ "legalBasis" . $request_type },
        publish        => $parameters->{ "publish" . $request_type },
        publish_to =>
            $parameters->{ "publishIdSpecification" . $request_type },
        disclosure => $parameters->{ "disclosure" . $request_type },
        disclosure_to =>
            $parameters->{ "disclosureIdSpecification" . $request_type },
        disclosure_contract =>
            $parameters->{ "disclosureContract" . $request_type },
        storing         => $parameters->{"storing"},
        secure          => $parameters->{"secure"},
        completion      => $parameters->{"completion"},
        completion_date => $completion_date,
        objective       => $parameters->{ "objective" . $request_type },
        benefits        => $parameters->{ "benefits" . $request_type },
        responsible     => $parameters->{ "responsible" . $request_type },
        organisation    => $parameters->{ "organisation" . $request_type },
        population      => $parameters->{ "population" . $request_type },
        rec_approval    => $parameters->{recApproval},
        rec_approval_number => $parameters->{recApprovalNumber},
    };

    my $data_handling = $c->model('DB::DataHandling')->create($dh);

    my $request_history =
        $c->model('DB::RequestHistory')
        ->create(
        { %$dh, %$dr, status_date => $data_request->status_date, } );

    my $data_requests = [ $c->model('DB::DataRequest')
            ->search( { user_id => $c->stash->{user}->id } ) ];

    if ( $parameters->{Submit} == 2 ) {
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('request_edit'),
                [ $data_request->id ]
            )
        );
    }
    else {
        $c->stash(
            data_requests => $data_requests,
            parameters    => $parameters,
            template      => 'datarequest/list.tt2'
        );
    }
}

=head2 update_request

submit request update

=cut

sub update_request : Chained('object') : Args() {
    my ( $self, $c ) = @_;
    my $parameters   = $c->request->body_parameters;
    my $data_request = $c->stash->{object};
    my $dr           = {
        user_id         => $c->stash->{user}->id,
        request_type_id => $parameters->{requestType},
        status_id       => $parameters->{Submit},
        status_date     => undef,

    };
    $data_request->update($dr);
    my $data_categorys_rs = $c->model('DB::DataCategory');

    while ( my $row = $data_categorys_rs->next ) {
        if ( defined( $parameters->{ $row->category } )
            && $parameters->{ $row->category } eq 'on' )
        {
            $c->model('DB::DataRequestDetail')->update_or_create(
                {   data_request_id  => $data_request->id,
                    data_category_id => $row->id,
                    detail => $parameters->{ $row->category . "Details" },
                }
            );
            $c->model('DB::RequestDetailHistory')->create(
                {   data_request_id  => $data_request->id,
                    data_category_id => $row->id,
                    detail => $parameters->{ $row->category . "Details" },
                    status_date => $data_request->status_date,
                }
            );
        }
        else {
            my $request_detail_rs =
                $c->model('DB::DataRequestDetail')->search(
                {   data_request_id  => $data_request->id,
                    data_category_id => $row->id,
                }
                );
            $request_detail_rs->delete;
        }
    }

    my $request_type = $data_request->request_type_id;
    $self->{identifiers} = $parameters->{ "identifiers" . $request_type };
    my $completion_date =
        $self->validate_date( $parameters->{completion_date} );
    my $dh = {
        request_id      => $data_request->id,
        area            => $parameters->{ "area" . $request_type },
        identifiable    => $parameters->{ "identifiable" . $request_type },
        publish         => $parameters->{ "publish" . $request_type },
        disclosure      => $parameters->{ "disclosure" . $request_type },
        storing         => $parameters->{"storing"},
        secure          => $parameters->{"secure"},
        completion      => $parameters->{"completion"},
        completion_date => $completion_date,
        objective       => $parameters->{ "objective" . $request_type },
        benefits        => $parameters->{ "benefits" . $request_type },
        responsible     => $parameters->{ "responsible" . $request_type },
        organisation    => $parameters->{ "organisation" . $request_type },
        population      => $parameters->{ "population" . $request_type },
        rec_approval    => $parameters->{recApproval},

    };

    if ( $dh->{identifiable} eq "1" ) {
        $dh->{identifiers}    = $self->_identifiers;
        $dh->{legal_basis_id} = $parameters->{ "legalBasis" . $request_type };
        $dh->{pid_justify}    = $parameters->{ "pidJustify" . $request_type };
    }
    else {
        $dh->{identifiers}    = '';
        $dh->{legal_basis_id} = undef;
        $dh->{pid_justify}    = '';
        $dh->{disclosure}     = 0;
    }
    if ( $dh->{publish} eq "1" ) {
        $dh->{publish_to} =
            $parameters->{ "publishIdSpecification" . $request_type };
    }
    else {
        $dh->{publish_to} = '';
    }
    if ( $dh->{disclosure} eq "1" ) {
        $dh->{disclosure_to} =
            $parameters->{ "disclosureIdSpecification" . $request_type };
        $dh->{disclosure_contract} =
            $parameters->{ "disclosureContract" . $request_type };
    }
    else {
        $dh->{disclosure_to}       = '';
        $dh->{disclosure_contract} = '';
    }
    if ( $dh->{rec_approval} eq "1" ) {
        $dh->{rec_approval_number} = $parameters->{recApprovalNumber};
    }
    else {
        $dh->{rec_approval_number} = undef;
    }

    my $data_handling_rs = $c->model('DB::DataHandling')
        ->search( { request_id => $data_request->id } );
    my $data_handling = $data_handling_rs->first;
    if ( defined $data_handling ) {
        $data_handling->update($dh);
    }
    else {
        $data_handling = $c->model->('DB::DataHandling')->create($dh);
    }

    my $request_history =
        $c->model('DB::RequestHistory')->create( { %$dr, %$dh } );

    if ( $data_request->status_id == 7 ) {
        $data_request->verify_purpose->delete
            if defined( $data_request->verify_purpose );
        $data_request->verify_handling->delete
            if defined( $data_request->verify_handling );
        $data_request->verify_manage->delete
            if defined( $data_request->verify_manage );
        $data_request->verify_data->delete
            if defined( $data_request->verify_data );
    }
    if ( $parameters->{Submit} == 2 ) {
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('request_edit'),
                [ $data_request->id ]
            )
        );
    }
    else {
        my $data_requests = [ $c->model('DB::DataRequest')
                ->search( { user_id => $c->stash->{user}->id } ) ];

        $c->stash(
            status_msg    => "Request " . $data_request->id . " updated",
            data_requests => $data_requests,
            parameters    => $parameters,
            template      => 'datarequest/list.tt2'
        );
    }
}

=head2 request_edit

Edit an open request

=cut

sub request_edit : Chained('object') : Args() {
    my ( $self, $c ) = @_;
    my $data_request = $c->stash->{object};
    $c->detach('/error_noperms')
        if $data_request->status_id == 4;
    my $user = $data_request->user;

    my $data_categorys_rs = $c->model('DB::DataCategory');
    my $data_categorys    = [ $data_categorys_rs->all ];

    my $data            = {};
    my $request_details = [ $data_request->data_request_details ];
    for my $detail (@$request_details) {
        my $data_category =
            $data_categorys_rs->find( { id => $detail->data_category_id } );
        $data->{ $data_category->category . 'Details' } = $detail->detail;
    }
    $data->{requestType} = $data_request->request_type_id;
    $data->{requestTypeDescription} =
        $data_request->request_type->description;
    $data->{requestTypeName} = $data_request->request_type->name;
    my $request = {
        id        => $data_request->id,
        status_id => $data_request->status_id,
        user      => {
            firstName => $user->first_name,
            lastName  => $user->last_name
        },
        data => $data,
    };

    my $request_types = [ $c->model('DB::RequestType')->all ];

    my $dh_rs = $c->model('DB::DataHandling')
        ->search( { request_id => $data_request->id } );
    my $dh = $dh_rs->first;

    my $request_type = $data_request->request_type_id;
    if ( defined $dh ) {
        $request->{data}->{ "identifiable" . $request_type } =
            $dh->identifiable;
        if ( $dh->identifiers =~ /, / ) {
            my @ids = split /, /, $dh->identifiers;
            for my $id (@ids) {
                $request->{data}->{identifiers}->{$id} = 1;
            }
        }
        elsif ( $dh->identifiers =~ /(\w+)/g ) {
            $request->{data}->{identifiers}->{$1} = 1;
        }
        $request->{data}->{ "pidJustify" . $request_type } = $dh->pid_justify;
        $request->{data}->{ "legalBasis" . $request_type } =
            $dh->legal_basis_id;
        $request->{data}->{ "publish" . $request_type } = $dh->publish;
        $request->{data}->{ "publishIdSpecification" . $request_type } =
            $dh->publish_to;
        $request->{data}->{ "disclosure" . $request_type } = $dh->disclosure;
        $request->{data}->{ "disclosureIdSpecification" . $request_type } =
            $dh->disclosure_to;
        $request->{data}->{ "disclosureContract" . $request_type } =
            $dh->disclosure_contract;
        $request->{data}->{"storing"}        = $dh->storing;
        $request->{data}->{"secure"}         = $dh->secure;
        $request->{data}->{"completion"}     = $dh->completion;
        $request->{data}->{"completionDate"} = $dh->completion_date->ymd
            if $dh->completion_date;
        $request->{data}->{ "objective" . $request_type } = $dh->objective;
        $request->{data}->{ "benefits" . $request_type }  = $dh->benefits;
        $request->{data}->{ "responsible" . $request_type } =
            $dh->responsible;
        $request->{data}->{ "organisation" . $request_type } =
            $dh->organisation;
        $request->{data}->{ "population" . $request_type } = $dh->population;
        $request->{data}->{ "area" . $request_type }       = $dh->area;
        $request->{data}->{recApproval}       = $dh->rec_approval;
        $request->{data}->{recApprovalNumber} = $dh->rec_approval_number;
    }

    my $legal_basis = [ $c->model('DB::LegalBasis')->all ];

    my $verify_purpose = $data_request->verify_purpose;
    if ( defined($verify_purpose) ) {
        $c->stash->{verify}->{purpose_user_name} =
            $verify_purpose->verifier->fullname;
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

    my $verify_handling = $data_request->verify_handling;
    if ( defined($verify_handling) ) {
        $c->stash->{verify}->{handling_user_name} =
            $verify_handling->verifier->fullname;
        $c->stash->{verify}->{rec_comment} = $verify_handling->rec_comment;
        $c->stash->{verify}->{population_comment} =
            $verify_handling->population_comment;
        $c->stash->{verify}->{id_comment} = $verify_handling->id_comment;
        $c->stash->{verify}->{publish_comment} =
            $verify_handling->publish_comment;
    }

    my $verify_manage = $data_request->verify_manage;
    if ( defined($verify_manage) ) {
        $c->stash->{verify}->{manage_user_name} =
            $verify_manage->verifier->fullname;
        $c->stash->{verify}->{storing_comment} =
            $verify_manage->storing_comment;
        $c->stash->{verify}->{secure_comment} =
            $verify_manage->secure_comment;
        $c->stash->{verify}->{completion_comment} =
            $verify_manage->completion_comment;
    }

    my $verify_data = $data_request->verify_data;
    if ( defined($verify_data) ) {
        $c->stash->{verify}->{data_user_name} =
            $verify_data->verifier->fullname;
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
    my $pt_identifiers = [ $c->model('DB::PtIdentifier')->all ];

    $c->stash(
        data_categorys => $data_categorys,
        requestor      => $user,
        request_types  => $request_types,
        request        => $request,
        legal_basis    => $legal_basis,
        pt_identifiers => $pt_identifiers,
        template       => 'datarequest/request.tt2'
    );
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
